class Volunteer < ApplicationRecord
    extend UpdatableFromCsv, ModelHelper
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


    def isMember?
        self.is_member
    end

    def isGuest?
        not self.is_member
    end


    # Find avaailble mentor
    # Someone in the active mentoring cycle
    # Who has the least amount of mentees
    def next_mentor
       #TODO: what would be the sql for next mentor?
    end

    class ToastmastersVolunteer < Volunteer

        FREE_TOAST_HOST = :freeToastHost
        TM_HQ = :ToastmastersInternational


        def self.getImportMapping(csvFileObj)
            case detectCsvFileType(csvFileObj)
            when Volunteer::ToastmastersVolunteer::FREE_TOAST_HOST
                return ToastmastersVolunteer::IMPORT_MAPPING_FREE_TOAST_HOST
            when Volunteer::ToastmastersVolunteer::TM_HQ
                return ToastmastersVolunteer::IMPORT_MAPPING_TM_HQ
            else
                raise "Can't figure out mapping for csvFileObj:\n#{csvFileObj}\n"
            end
        end

        def self.detectCsvFileType(csvFileObj)
            headers = csvFileObj.first.to_h.keys
            if headers.include?('Customer ID')
                return Volunteer::ToastmastersVolunteer::TM_HQ
            elsif headers.include?('ROLESTATUS')
                return Volunteer::ToastmastersVolunteer::FREE_TOAST_HOST
            end

            return nil
        end

        IMPORT_MAPPING_FREE_TOAST_HOST = {
            name: "NAME",
            email: "EMAIL",
            cell: "PHONE",
            tie_breaker_uuid: {
                code:   Proc.new { (SecureRandom.uuid)},
            },
            last_synched: {
                literal:    DateTime.now(),
            }
        }

        IMPORT_MAPPING_TM_HQ = {
            name: "Name",
            email: "Email",
            cell: "Mobile Phone",
            tie_breaker_uuid: {
                code:   Proc.new { (SecureRandom.uuid)},
            },
            last_synched: {
                literal:   DateTime.now(),
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
