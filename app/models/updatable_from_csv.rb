module UpdatableFromCsv
    # Ideally I'd like this to be in sge/lib/prompt.rb,
    # but I was having trouble loading it (circular dependency)
    # Returns false if the user does not enter Y or timeouts
    def get_prompt(question, timeoutSecs = 10)
      require 'timeout'
      STDOUT.print "#{question} (Y/n) > "

      begin
        prompt = Timeout::timeout(timeoutSecs) { STDIN.gets.chomp }
        if prompt == 'Y'
          return true
        else
          return false
        end
      rescue Timeout::Error
        puts "\nTimeout exceeded..... doing nothing!"
        return false
      end
    end


    def log_not_imported(hashes)
        require 'pp'
        logLocation = 'log/import_clients.log'
      File.open(logLocation, "ab") do |f|
        hashes.each {|hash| f.puts "Could not import #{hash.pretty_inspect}"}
      end

        return logLocation
    end


    def guessMapping(csvFileObj, mapping)
        if mapping.nil?
            if self.class.const_defined?('IMPORT_MAPPING')
                mapping = self::IMPORT_MAPPING
            elsif self.respond_to?('getImportMapping')
                mapping = self::getImportMapping(csvFileObj)
            else
                raise "No mapping defined: all mapping argument, #{self.name}.IMPORT_MAPPING constant and getImportMapping method are nil or don't exist"
            end
        end

        if not mapping.is_a?({}.class)
            raise "Somehow I did not end up with a hash for mapping.  mapping was a #{mapping.class}: #{mapping}"
        end

        return mapping
    end


    ########################################################################
    # Update data in models according to csv file
    # @param [String] filePath The path of the file
    # @param [Hash] mapping Mapping of model attribute (in the form of a symbol) => csv header (string)
    #               If you need to feed it an object, use
    #                    :modelAttribute => {
    #                       :csvHeader  => "$csvHeaderName",
    #                       :code       => Proc.new { |csvValue| Client.find(csvValue) }]
    #                     }
    #               If you need to feed it either two values, give it
    #                   :modelAttribute => ["csvHeader1", "$csvHeader2"]
    #               If you need to feed it a constant, give it
    #                   :modelAttribute => {:literal => false}
    #                   :modelAttribute => {:literal => 3}
    #                   :modelAttribute => {:literal => "a string"}
    #               The method will take care of plucking the csvValue in the right spot.
    #               The value between || needs to be somewhere in your code block
    # @param [Hash] primaryKeyColumn A hash with {csvColumn => :modelAttribute}
    #               used to match row to object for updating
    #               nil : defaults to using self.IMPORT_PRIMARY_KEY
    #               false : Don't update, just create (not implemented)
    # @param [Hash] options Give the follow options
    # @opts [boolean] :dontCreate Report object as error if can't be found
    # @opts [boolean] :truncate trunate Truncate the table before. Not implemented.
    ########################################################################
    def update_from_csv(filePath, mapping = nil, primaryKeyColumn = nil, options = {})
        require 'csv'


        seperator = options[:seperator]
        seperator = self::detectSeperator(filePath) if seperator.nil?
        notLoaded   = []
        dataInHashes = []
        CSV.open(filePath, 'rb', headers: :first_row, encoding: 'UTF-8', col_sep: seperator) do |csv|

            mapping = guessMapping(csv, mapping)

            totalLines = `wc -l "#{filePath}"`.strip.split(' ')[0].to_i - 1

            if not Rails.env.test?
                next unless get_prompt("Load #{filePath} (#{totalLines} lines)?")
            end

            count = 0
            csv.each do |row|
                count += 1
                printProgress("Reading #{filePath}", count, totalLines)
                entry = {}
                begin
                    entry = processMappingAndRow(row, mapping)
                    dataInHashes << entry
                rescue => e
                    entry[:errorMsg] = e.message
                    notLoaded << entry
                    if notLoaded.count < 4
                        $stderr.puts "Could not read following row \n#{row}\n  ... because #{e.message}"
                        byebug
                        nil
                    end
                end
            end
            puts "\n"

            total = dataInHashes.length
            count = 0

            #Create a hash of stats
            desiredStats = ["Objects created", "Objects updated"]
            stats = Hash[desiredStats.collect {|stat| [stat, 0]}]


            puts "#{self.count} #{self.name} objects in database before creation"
            dataInHashes.each do |dataEntry|
                count += 1
                printProgress("Updating / creating data", count, totalLines)
                object = nil

                begin

                    primaryKeyColumn = self::IMPORT_PRIMARY_KEY if primaryKeyColumn.nil?

                    #byebug if dataEntry[primaryKeyColumn] == 'bsoppethb@qq.com'

                    if primaryKeyColumn.is_a?({}.class)
                        key = primaryKeyColumn.keys.first
                    elsif primaryKeyColumn.is_a?(Symbol)
                        key = primaryKeyColumn
                    elsif not primaryKeyColumn.nil?
                        raise "Don't know what to do with a #{primaryKeyColumn.class}"
                    end

                    raise "Not sure I should have a nil or empty key.  Primary key column was #{primaryKeyColumn}" if (key.nil? or key.empty?)

                    object = findObject(dataEntry, key)

                    if object.nil?
                        # Object not found lets create
                        raise "Can't find #{dataEntry}, not creating" if options[:dontCreate]  == true
                        self.create!(cloneWithoutCommentKeys(dataEntry))
                        stats["Objects created"] += 1
                    else
                        # Object found, lets update
                        object.update(cloneWithoutCommentKeys(dataEntry))
                        object.save!
                        stats["Objects updated"] += 1
                    end
                rescue => e
                    dataEntry[:errorMsg] = e.message
                    notLoaded << dataEntry
                    $stderr.puts "Could not update or create #{dataEntry}" if notLoaded.count < 4
                    $stderr.puts e.backtrace if notLoaded.count <= 2
                end
            end
            puts "\n"
            puts "#{self.count} #{self.name} objects in database after creation"


            stats["Rows not imported"] = notLoaded.count
            stats.each {|label, number| puts "#{label}: #{number}"}

            if notLoaded.count > 0
                logLocation = log_not_imported(notLoaded)
                $stderr.puts "See #{Rails.root}/#{logLocation} for details on not loaded objects"
            end

        end

    end

    protected

    def cloneWithoutCommentKeys(hash)
        copy = hash.clone

        copy.each { |key, value|
            if key.is_a?(String) and key.start_with?('#')
                copy.delete(key)
            end
        }
        return copy
    end

    def findObject(dataEntry, key)
        raise "No way to find primary key #{key} in #{dataEntry}" if not dataEntry.keys.include?(key)
        value = dataEntry[key]
        raise "Null primary key with key #{key} and data #{dataEntry}" if value.nil?
        object = self.find_by("#{key.to_s} = ?", value)
    end

    ########################################################################
    # See documentation for update_from_csv
    ########################################################################
    def processMappingAndRow(row, mapping)
        returnHash = {}
        mapping.each { |classAttribute, csvHandler|
            value = nil

            case csvHandler.class.name
            when "String"
                # Here, we just want the value of the cell from the column
                # that has the value in csvHandler as a column
                value = row[csvHandler]

                # TODO:
                # Detect if it's an assocation, and if it is, use
                # reflection to get the class
                # See https://stackoverflow.com/questions/3234991/what-is-the-class-of-an-association-based-on-the-foreign-key-attribute-only
                if not self.reflect_on_association(classAttribute).nil?
                     associationClassName = self.reflect_on_association(classAttribute).class_name
                     assocClass = Object.const_get(associationClassName)
                     value = assocClass.find(value)
                end


            when "Array"
                # This should probably changed to a hash, where you
                # can feed it the keys :columns and :default

                # We are picking the first non false value of the array
                value = row.to_h.select {|k,v|
                    #Keep the elements of the row specified in csvHandler
                    csvHandler.include?(k)
                 }

                # select the ones that return true, and pick the first value
                value = value.select {|k,v| v}.values.first

                if value.nil?
                    value = csvHandler.last
                end

            when "Hash"
                if csvHandler.keys.first == :literal
                    value = csvHandler.values.first

                elsif csvHandler.keys.include?(:code)
                    raise ":code does not have a Proc for attribute #{classAttribute}.  The csvHandler is :\n#{csvHandler}" if not (csvHandler[:code].is_a?(Proc))
                    if csvHandler.keys.include?(:csvHeader)
                        value = csvHandler[:code].call(row[csvHandler[:csvHeader]])
                    else
                        value = csvHandler[:code].call()
                    end

                else
                    raise "Don't know what to do with the hash #{csvHandler.to_s}"
                end
            else
                byebug
                nil
                raise "Don't know what to do with a csvHandler of type #{csvHandler.class.name} for attribute #{classAttribute}.  The csvHandler is :\n#{csvHandler.to_s}"
            end


            returnHash[classAttribute]  = value
        }

        returnHash
    end
end
