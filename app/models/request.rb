class Request < ApplicationRecord
  extend UpdatableFromCsv, ModelHelper
  belongs_to :volunteer
  belongs_to :prefered_role
  belongs_to :meeting
end
