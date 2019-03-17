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

end
