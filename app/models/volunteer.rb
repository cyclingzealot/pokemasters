class Volunteer < ApplicationRecord
    extend UpdatableFromCsv, ModelHelper
#class Volunteer < ApplicationRecord
    #belongs_to :last_request
    #belongs_to :last_assignment
    #belongs_to :chapter
    #belongs_to :next_role

    #Reading https://stackoverflow.com/questions/2780798/has-and-belongs-to-many-vs-has-many-through#2781049, it seems we need to use a has_many through: because of organization (See VolunteerTaggins)
    #has_and_belongs_to_many :volunteer_tags, through: :volunteer_tagging

    has_many :volunteer_attributes

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

    def level(org: Organization.find(1))
        rolesDone = Assignment.where(volunteer: self).joins(:role).joins(:meeting).where('meetings.organization_id': org.id)

        return (rolesDone.maximum('roles.level') or 0)
    end

    def register(organization:, level: 0)
        r = Registration.find_or_create_by(organization: organization, volunteer: self)
        r.level = level
        r.save!
    end


    def mentor!
        #You're going to have to go through volunteer taggings
        #This volunteer tag is silly.  Are there that many tags?
        #Yes, what is a volunteer can differ according to different organizations,
        #but how many tags can they have?  mentor, guest, alumni, senior, charismatic,
        #Reading https://stackoverflow.com/questions/2780798/has-and-belongs-to-many-vs-has-many-through#2781049, it seems we need to use a has_many through:

        #self.volunteer_tags << VolunteerTag.find_by_short_name("mentor")

        va = VolunteerAttribute.find_or_create_by(organization_id: 1, volunteer: self)

        va.mentor = true

        va.save!
    end

    def mentor?
        VolunteerAttribute.where(organization_id: 1, volunteer: self, mentor: true).count >= 1
    end


    def isMember?
        self.is_member
    end

    def isGuest?
        not self.is_member
    end

    def to_s
        "{#{id}}#{name} (#{email})"
    end


    # Find avaailble mentor
    # Someone in the active mentoring cycle
    # Who has the least amount of mentees
    def self.next_mentor
        # This query willl get you a mentor that has the least mentee,
        mentoringCycle = MentoringCycle.current_or_create
        nextMentorVolunteerId = Volunteer.joins(:volunteer_attributes).joins("LEFT JOIN mentorings on mentor_id = volunteers.id").where('volunteer_attributes.mentor': true).group("volunteers.id").order('count_mentee_id, RANDOM()').count("mentee_id").keys.first
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
            headers = csvFileObj.headers
            if headers.map{|s| s.to_s}.include?("Member has opted-out of Toastmasters WHQ marketing mail")
                return Volunteer::ToastmastersVolunteer::TM_HQ
            elsif headers.map{|s| s.to_s}.include?("Customer ID")
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
