class Registration < ApplicationRecord
    belongs_to :organization
    belongs_to :volunteer


    validates :volunteer, uniqueness: {scope: :organization}

    attr_accessor :level
end
