require 'test_helper'

class MentoringTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

    test "it should assign a mentor to a mentee" do
        mentor = Volunteer.find_available_mentor()

        mentee = Volunteer.find_available_mentee()

        m = Mentoring.new(mentor: mentor, mentee: mentee)


        m.save!



    end


end
