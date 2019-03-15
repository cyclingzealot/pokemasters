require 'test_helper'

class AssignmentTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end

  test "Assign a volunteer to a meeting" do
    VolunteerTest::populateDb()

    v1 = Volunteer.find_by_email('gkidstone2@spotify.com')

    assert_not_nil v1

    m = Meeting.new("2019/03/15 18:55", "Robertston 617")
    r = Role.snameLike('ge').first

    m.assign(v1, r)
    #a = Assignment.new(volunteer: v1, meeting: m, role: r)
  end
end
