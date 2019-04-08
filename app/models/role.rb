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
        r = find_by_short_name(searchStr)
        byebug if r.nil? and Rails.env.development?
        return r
    end

    def suggestVolunteers

        ## The two queries sort by participation regardless of what role was done.  How and in what case do we rotate so that it's the person who has not done this role?
        ## It needs to be by particpation date of the role in question
        ## There probably needs to be some additional logic here
        ## What about the people who have never participated?

        qualifiedVolunteers = Volunteer.joins(:registration).
            joins(assignments: :roles).
            joins(assignments: :meetings).
            where('meetings.organization_id':  self.organization.id).   #What is a role?  Is it something that is part of an organization?  Yes
            where("roles.level >= #{self.level - 1}").
            order('meetings.datetime ASC')
        #Always find someone eligeable who has not done the role

        if qualifiedVolunteers.count == 0
	        qualifiedVolunteers = Volunteer.joins(:registration).
	            joins(assignments: :roles).
	            joins(assignments: :meetings).
	            where('meetings.organization':       self.organization).
	            where('registrations.organization':  self.organization).
	            order('roles.level, meetings.datetime ASC')
        end



        return qualifiedVolunteers

    end



end
