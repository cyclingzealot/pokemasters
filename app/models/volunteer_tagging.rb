class VolunteerTagging < ApplicationRecord
  belongs_to :volunteer
  belongs_to :volunteer_tag
  belongs_to :organization
end
