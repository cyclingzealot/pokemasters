class Volunteer < ApplicationRecord
    extend UpdatableFromCsv
#class Volunteer < ApplicationRecord
    #belongs_to :last_request
    #belongs_to :last_assignment
    #belongs_to :chapter
    #belongs_to :next_role

    def self.import(filePath)
        require 'csv'
        require 'securerandom'

        filePath = guessFilePath(filePath)

        sep = detectSeperator(filePath)

        CSV.open(filePath, 'rb', headers: :first_row, encoding: 'UTF-8', col_sep: sep) do |csv|
            csv.each {|row|
            }
        end

    end


    class ToastmastersVolunteer < Volunteer

        FREE_TOAST_HOST = :freeToastHost
        TM_HQ = :ToastmastersInternational

        def self.import(csvFile)
            case detectCsvFileType(csvFile)
            when Volunteer::ToastmastersVolunteer::FREE_TOAST_HOST
            when Volunteer::ToastmastersVolunteer::TM_HQ
            end
        end

        def self.detectCsvFileType(csvFile)
            if csvFile.headers.include?('Customer ID')
                return Volunteer::ToastmastersVolunteer::TM_HQ
            elsif csvFile.headers.include?('ROLESTATUS')
                return Volunteer::ToastmastersVolunteer::FREE_TOAST_HOST
            end

            return nil
        end

        IMPORT_MAPPING_FREE_TOAST_HOST = {
            name: "NAME",
            email: "EMAIL",
            cell: "PHONE",
            tie_breaker_uuid: SecureRandom.uuid,
            last_synched: DateTime.now(),
        }

        IMPORT_MAPPING_TM_HQ = {
            name: "Name",
            email: "Email",
            cell: "Mobile Phone",
            tie_breaker_uuid: {
                code:   SecureRandom.uuid,
            },
            last_synched: {
                code:   DateTime.now(),
            },
            is_member: {
                csvHeader: "Paid Until",
                code:   Proc.new {|csvValue| (Date.today <= Date.parse(csvValue))}
            },
            external_org_id: "Customer ID",
        }

        IMPORT_PRIMARY_KEY = :email



    end
end
