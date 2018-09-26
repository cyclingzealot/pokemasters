class VolunteerAttribute < ApplicationRecord

    belongs_to :organization
    belongs_to :volunteer
end
