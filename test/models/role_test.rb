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
    self.class.populateDb
    r = Role.find_by_sname('timer')

    byebug if r.nil? and Rails.env.test?


    assert_not_nil r, "No timer role found"

    r.suggestVolunteers.each {|v| assert_equal v.assignments.count, 0, "This volunteer had previous assinments"}
  end

  test "It will not suggest not volunteers who already has a role" do
        skip("Needs work")
  end

  test "It will not suggest not volunteers who already has that role in an upcoming meeting" do
        skip("Needs work")
  end

  test "Once there are no volunteers to pick from, pick someone who has done the furthest away who has no role in the meetings in the next 2 weeks" do
    self.class.populateDb


    r = Role.find_by_sname('timer')

    byebug if r.nil? and Rails.env.test?

    assert_not_nil r, "No timer role found"

    r.suggestVolunteers.each {|r| skip("This test requires further implementation") }
  end

  test "It will suggest chair for someone who has not done it and is of sufficient level" do
    skip("Need to develop scenario")
  end




end
