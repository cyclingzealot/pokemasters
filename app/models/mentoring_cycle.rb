class MentoringCycle < ApplicationRecord


    def self.current_or_create()
        mc = current
        case mc.count
        when 1
            return mc.first
        when 0
            mc = new(start_date: Date.today)
            mc.save!
            return mc
        else
            raise "More than one mentoring cycle found!"
        end
    end

    def self.current
        mc = MentoringCycle.where('start_date <= ?', Date.today).where('end_date >= ? or end_date is null', Date.today)
    end
end
