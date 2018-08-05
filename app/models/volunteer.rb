class Volunteer < ApplicationRecord
    extend UpdatableFromCsv, ModelHelper
#class Volunteer < ApplicationRecord
    #belongs_to :last_request
    #belongs_to :last_assignment
    #belongs_to :chapter
    #belongs_to :next_role

    #Reading https://stackoverflow.com/questions/2780798/has-and-belongs-to-many-vs-has-many-through#2781049, it seems we need to use a has_many through: because of organization (See VolunteerTaggins)
    has_and_belongs_to_many :volunteer_tag

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


    def isMentor!
        #You're going to have to go through volunteer taggings
        #This volunteer tag is silly.  Are there that many tags?
        #Yes, what is a volunteer can differ according to different organizations,
        #but how many tags can they have?  mentor, guest, alumni, senior, charismatic,
        #Reading https://stackoverflow.com/questions/2780798/has-and-belongs-to-many-vs-has-many-through#2781049, it seems we need to use a has_many through:
        self.volunteer_tags << VolunteerTag.find_by_short_name("mentor")
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
    def self.next_mentor
        # This query willl get you a mentor that doesn't has the least mentee, although it doesn't take into consideration
        # Which volunteer have been tagged as mentor nor which is the current mentoring cycle
        # Volunteer tags has been implemented, but we still have to join it thorugh volunteer taggings
        # and get the current mentoring cycle
        mentoringCycle = MentoringCycle.current_or_create
        nextMentorVolunteerId = Volunteer.joins("LEFT JOIN mentorings on mentor_id = volunteers.id").group("volunteers.id").order('count_mentee_id, RANDOM()').count("mentee_id").keys.first
        v = Volunteer.find(nextMentorVolunteerId)
        return v
    end

    def self.next_mentee
        mc = MentoringCycle.current_or_create

        # TODO: this could be redone as a simple query on mentorings table
        nextMenteeVolunteerId = Volunteer.joins("LEFT JOIN mentorings on mentee_id = volunteers.id and mentorings.id = #{mc.id}").group("volunteers.id").having("count(mentor_id)< ?", 2).order('count_mentor_id, RANDOM()').count("mentor_id").keys.first

        v = Volunteer.find(nextMenteeVolunteerId)
        return v
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
