class Request < ApplicationRecord
  belongs_to :volunteer
  belongs_to :prefered_role
  belongs_to :meeting
end
