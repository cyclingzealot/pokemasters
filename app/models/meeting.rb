class Meeting < ApplicationRecord


    def assign(volunteer, role)
        a = Assignment.new(volunteer: volunteer, role: role, meeting: self)
        a.save!
    end
        
end
