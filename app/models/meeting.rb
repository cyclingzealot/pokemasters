class Meeting < ApplicationRecord

    attr_reader :datetime
    attr_reader :location

    def assign(volunteer, role)
        a = Assignment.new(volunteer: volunteer, role: role, meeting: self)
        #a.save
        return a
    end

    def initialize(datetime, where)
        @datetime = DateTime.parse(datetime)
        @location = where
    end

end
