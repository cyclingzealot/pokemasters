class Volunteer < ApplicationRecord
  belongs_to :last_request
  belongs_to :last_assignment
  belongs_to :chapter
  belongs_to :next_role
end
