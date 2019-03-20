class Role < ApplicationRecord
    extend UpdatableFromCsv, ModelHelper

    validates :short_name, :human_name, presence: true

    def self.snameLike(searchStr)
        sNameLike(searchStr)
    end

    def self.sNameLike(searchStr)
        likeStr = "like"
        likeStr = "ilike" if ActiveRecord::Base.connection.instance_values["config"][:adapter] == "postgresql"
        where(%Q[short_name #{likeStr} '%#{searchStr}%'])
    end

    def self.find_by_sname(searchStr)
        find_by_short_name(searchStr)
    end

    def suggestVolunteer
        qualifiedVolunteers = Volunteer.joins(:registrations).joins(assignments: :roles).joins(assignments: :meetings).where('registrations.organization_id':  organization.id).where("roles.level >= #{self.level - 1}").order('meetings.datetime ASC')
        #Always find someone eligeable who has not done the role

        if qualifiedVolunteers == 0
            #If no one, rank by last done.
        end

    end



end
