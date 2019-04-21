class Role < ApplicationRecord
    extend UpdatableFromCsv, ModelHelper

    validates :short_name, :human_name, presence: true


    belongs_to :organization




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

        baseQuery = Volunteer.joins(:registration).joins(:assignments)

        maxVolunteers = 4
        maxTries = 4
        tries = 0
        while(possibleVolunteers.count < maxVolunteers) do
            tries += 1

            case tries
            #1. Has previous level, never done role, order by partication dat ASC
            when 1
                vols = baseQuery.
                    where("registrations.level":  self.level - 1).
                    order('meetings.datetime ASC')

                possibleVolunteers.add(vols)

            #2. Has adequate level, never have done role, order by partication date ASC
            when 2
                vols = baseQuery.
                    where("registrations.level >= #{self.level - 1}").
                    order('meetings.datetime ASC')

                possibleVolunteers.add(vols)

            #3. Has max level, may have done role, order by last time role done
            when 3
                maxLevel = Role.where(organization: self.organization).maximum(:level)

                raise "This needs further work. join basequery with assignmens and find those who have done the role?"

            #4. Don't look at level, last participation date
            when maxTries
            end

        end





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



        return qualifiedVolunteers

    end



end
