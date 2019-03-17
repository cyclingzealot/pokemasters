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
        #Always find someone eligeable who has not done the role
        #If no one, rank by last done.

    end



end
