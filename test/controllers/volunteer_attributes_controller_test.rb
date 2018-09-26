require 'test_helper'

class VolunteerAttributesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @volunteer_attribute = volunteer_attributes(:one)
  end

  test "should get index" do
    get volunteer_attributes_url
    assert_response :success
  end

  test "should get new" do
    get new_volunteer_attribute_url
    assert_response :success
  end

#  test "should create volunteer_attribute" do
#    assert_difference('VolunteerAttribute.count') do
#      post volunteer_attributes_url, params: { volunteer_attribute: { mentor: @volunteer_attribute.mentor, organization: @volunteer_attribute.organization, volunteer: @volunteer_attribute.volunteer } }
#    end
#
#    assert_redirected_to volunteer_attribute_url(VolunteerAttribute.last)
#  end

  test "should show volunteer_attribute" do
    get volunteer_attribute_url(@volunteer_attribute)
    assert_response :success
  end

  test "should get edit" do
    get edit_volunteer_attribute_url(@volunteer_attribute)
    assert_response :success
  end

#  test "should update volunteer_attribute" do
#    patch volunteer_attribute_url(@volunteer_attribute), params: { volunteer_attribute: { mentor: @volunteer_attribute.mentor, organization: @volunteer_attribute.organization, volunteer: @volunteer_attribute.volunteer } }
#    assert_redirected_to volunteer_attribute_url(@volunteer_attribute)
#  end

  test "should destroy volunteer_attribute" do
    assert_difference('VolunteerAttribute.count', -1) do
      delete volunteer_attribute_url(@volunteer_attribute)
    end

    assert_redirected_to volunteer_attributes_url
  end
end
