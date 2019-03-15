class Assignment < ApplicationRecord
  belongs_to :volunteer
  belongs_to :meeting
  belongs_to :role


  def initialize(volunteer:, meeting:, role:)
    @volunteer = volunteer
    @meeting   = meeting
    @role      = role
  end
end
