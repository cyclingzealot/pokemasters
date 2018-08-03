require 'test_helper'

class MentoringTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

    test "it should assign a mentor to a mentee" do
        VolunteerTest::populateDb
        mentor = Volunteer.next_mentor()

        assert mentor.class == Volunteer, "Mentor is a #{mentor.class}"

        mentee = Volunteer.next_mentee()

        assert mentee.class == Volunteer, "Mentee is a #{mentee.class}"

        m = Mentoring.assign(mentor:mentor, mentee:mentee)

        assert m.class == Mentoring, "Mentoring is a #{m.class}"



    end


end
