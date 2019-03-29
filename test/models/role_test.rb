require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end

  def self.populateDb()
    Role::update_from_csv('test/files/roles.csv')
  end


  test "It can load a csv file" do
    self.class.populateDb
    assert_operator Role.count, :>, 10
  end


  test "It will suggest only brand new volunteers" do
    Role.find_by_sname('timer').suggestVolunteers.each {|r| assert_equal r.assignments.count, 0, "This volunteer had previous assinments"}
  end


  test "Once there are no volunteers to pick from, pick someone who has done the furthest away who has no role in the meetings in the next 2 weeks" do
    Role.find_by_sname('timer').suggestVolunteers.each {|r| test_skip }
  end




end
