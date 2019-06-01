class Role < ApplicationRecord
    extend UpdatableFromCsv, ModelHelper

    validates :short_name, :human_name, presence: true


    belongs_to :organization


    has_many :assignment




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

        ## If you put the level in the registation, you could avoid having to join with assignments, meetings and roles so seek a qualified volunteer
        ## You could tend left join with assingments, in the hopes to order by last date involved.  You can get the minimum time avlue with Time.at(0)


        #What do you need?
        #the level of the role
        #The level of the volunteer (in registration)
        #The date the last role was done, if ever? (in assignments)


        #joins("LEFT JOIN student_enrollments ON courses.id = student_enrollments.course_id")

        possibleVolunteers = Set.new

        baseQuery = Volunteer.joins(:registration)
        baseQuery.count #THis is a test can be removed once working

        maxVolunteers = 4
        maxTries = 6
        tries = 0
        while(possibleVolunteers.count < maxVolunteers and tries <= maxTries) do
            tries +=  1

            case tries

            # Volunteer registered but never done anything.
            when 0
                vols = baseQuery.where("registrations.level <= ?", self.level).select{|v| v.assignments == 0}

                possibleVolunteers.merge(vols.to_a)

            # Has previous level, never done role, order by partication dat ASC
            when 2
                vols = baseQuery.joins(assignment: :meeting).
                    where("registrations.level = ?", self.level-1).   # Is at the previous level
                    where("assignments.role_id != ?", self.id).
                    order('meetings.date ASC')

                vols.to_sql

                possibleVolunteers.merge(vols.to_a)

            # Has adequate level, never have done role, order by partication date ASC
            when 3
                vols = baseQuery.joins(assignment: :meeting).
                    where("registrations.level >= #{self.level - 1}").
                    where("assignments.role_id != ?", self.id).
                    order('meetings.date ASC')

                vols.to_sql

                possibleVolunteers.merge(vols.to_a)

            # Has max level, may have done role, order by last time role done
            when 4
                maxLevel = Role.where(organization: self.organization).maximum(:level)


                vols = baseQuery.joins(assignment: :meeting).where("assignments.role": self).where('registrations.level': maxLevel).order('meetings.date')
                vols.to_sql
                # Remove from vols that have assignments in next meeting or ... same meeting or upcoming meetings?

                possibleVolunteers.merge(vols.to_a)

            #4. Don't look at level, last participation date
            when maxTries

                vols = baseQuery.left_outer_joins(assignment: :meeting).order('meetings.date')

                possibleVolunteers.merge(vols.to_a)
            end

        end


        #Maybe we still need to do this?  Removing for now.  It is, after all, suggestions
        #raise "You need to remove volunteers in all tries that have a future assignment.  Add a days prep property for roles"





=begin
        #Possible filter criterias:
        #- One previous level
        #- Adequetate level (one previous level or above)
        #- Max level
        #- Has neer done role, by participation date
        #- Has done role, by time you did role


        #OK, HERE IS THE ORDER:
        #1. First you try to find volunteers who are of the previous level who have never done the role, by participation date
        #2. If there are no suggestions or not enough, you do same as the previous step, without level criteria

        qualifiedVolunteers = Volunteer.joins(:registration).joins(:assignments).
            where("registrations.level >= #{self.level - 1}").
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
=end



        return possibleVolunteers

    end



end
