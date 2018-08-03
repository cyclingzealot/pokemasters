require 'test_helper'

class MentoringCycleTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end

  test "it should return the latest mentoring cycle, and if not, create one" do
    assert_not_nil MentoringCycle.current_or_create
  end

  test "it should prevent the creation of two mentoring cycles" do
    skip("Not focussing on mentoring cycles right now")
  end
end
