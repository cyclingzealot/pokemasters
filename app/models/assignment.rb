class Assignment < ApplicationRecord
  belongs_to :volunteer
  belongs_to :meeting
  belongs_to :role
end
