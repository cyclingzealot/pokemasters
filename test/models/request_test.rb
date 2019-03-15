require 'test_helper'

class RequestTest < ActiveSupport::TestCase
  test "the truth" do
     assert true
  end

  def self.populateDb()
      Role::update_from_csv('test/files/roles.csv')

  end

  test "It can determine the next volunteer for a role (more volunteers then roles)" do
=begin
    What is a good scenario here?  How to mituclouisy test 'oh you got the right role'?  Well, there are two possible state:
    1. We have an equal amount of roles and volunteers, or fewer volunteers then roles
    2. We have more volunteers then roles
=end

  end




end
