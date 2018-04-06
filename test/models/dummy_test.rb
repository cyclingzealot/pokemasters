require 'test_helper'

class DummyTest < ActiveSupport::TestCase
  test "the truth" do
     assert true
  end

  test "extending a module" do
    assert_equal "true", Dummy::returnsTheStringTrue
  end
end
