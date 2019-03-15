require 'test_helper'

class MeetingTest < ActiveSupport::TestCase


    test "I can create myself" do
        m = Meeting.new("2019/03/18 18:35", "Robertston 617")

        assert_not_nil m

        #m.save!
    end



end
