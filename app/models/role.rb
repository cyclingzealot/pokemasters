class Role < ApplicationRecord
    extend UpdatableFromCsv, ModelHelper

    def self.snameLike(searchStr)
        likeStr = "like"
        likeStr = "ilike" if ActiveRecord::Base.connection.instance_values["config"][:adapter] == "postgresql"
        where(%Q[short_name #{likeStr} '%#{searchStr}%'])
    end



end
