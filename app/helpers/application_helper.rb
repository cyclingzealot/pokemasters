module ApplicationHelper
    def detectSeperator(filePath)
        firstLine = File.open(filePath, &:readline)
        [',', ":", ";", "\t"].max_by{|s| firstLine.split(s).count}
    end


    def guessFilePath(filePath)
        filePath = [filePath, File.join(Rails.root, filePath)].select {|p|
            File.exists?(p)
        }[0]

        if filePath.nil?
            raise "No file found at #{filePath}"
        end

        return filePath
    end


    def extractHeaders
    end


    ########################################################################
    # Just print a line to indicate progress
    # @param [String] doingWhatStr What do you want to tell the user you are doing
    ########################################################################
    def printProgress(doingWhatStr, count, total, zeroBased = true)
        count =+ 1 if zeroBased
        puts "Started #{DateTime.now.strftime('%H:%M:%S')}" if count == 1
        progressStr = "#{count} / #{total} #{(count.to_f * 100/total).round} %"
        print ("\u001b[1000D" + progressStr + ' : ' + doingWhatStr)
        if count == total
            puts "\n"
            puts "Done #{DateTime.now.strftime('%H:%M:%S')}"
            puts "\n"
        else
            print '... '
        end
    end




end
