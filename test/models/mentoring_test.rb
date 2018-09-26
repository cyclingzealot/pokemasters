require 'test_helper'

class MentoringTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

    test "it should assign a mentor to a mentee" do
        VolunteerTest::populateDb

        Volunteer.order("RANDOM()").take(3).each {|v| v.mentor!}

        mentor = Volunteer.next_mentor()

        assert mentor.class == Volunteer, "Mentor is a #{mentor.class}"

        assert mentor.mentor?, "Volunteer #{mentor.to_s} is not a mentor"

        mentee = Volunteer.next_mentee()

        assert mentee.class == Volunteer, "Mentee is a #{mentee.class}"

        m = Mentoring.assign(mentor:mentor, mentee:mentee)

        assert m.class == Mentoring, "Mentoring is a #{m.class}"

    end

    test "it should make a list of mentor to mentee" do
        Mentoring.makeListFromFiles(volunteersList: ["test/files/Club-Roster20180402-shorter.csv", "test/files/membership-export-shorter.csv"], mentorEmails: "test/files/mentorEmails.csv")
    end


end
