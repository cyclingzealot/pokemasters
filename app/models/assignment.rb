class Assignment < ApplicationRecord
  belongs_to :volunteer
  belongs_to :meeting
  belongs_to :role

  validate :has_registration_with_org

  validates :volunteer, presence: true
  validates :meeting, presence: true
  validates :role, presence: true


  def initialize(volunteer: nil, meeting: nil, role: nil)
    @volunteer = volunteer
    @meeting   = meeting
    @role      = role
  end


    private

    def has_registration_with_org
        if not self.volunteer.isRegisteredTo?(organization: self.meeting.organization)
			errors.add(:meeting, "#{self.volunteer.to_s} is not registered to #{self.meeting.organization.to_s}")
		end
    end

end
