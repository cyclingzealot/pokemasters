require 'test_helper'

class VolunteerTaggingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @volunteer_tagging = volunteer_taggings(:one)
  end

  test "should get index" do
    get volunteer_taggings_url
    assert_response :success
  end

  test "should get new" do
    get new_volunteer_tagging_url
    assert_response :success
  end

  test "should create volunteer_tagging" do
    assert_difference('VolunteerTagging.count') do
      post volunteer_taggings_url, params: { volunteer_tagging: { organization_id: @volunteer_tagging.organization_id, volunteer_id: @volunteer_tagging.volunteer_id, volunteer_tag_id: @volunteer_tagging.volunteer_tag_id } }
    end

    assert_redirected_to volunteer_tagging_url(VolunteerTagging.last)
  end

  test "should show volunteer_tagging" do
    get volunteer_tagging_url(@volunteer_tagging)
    assert_response :success
  end

  test "should get edit" do
    get edit_volunteer_tagging_url(@volunteer_tagging)
    assert_response :success
  end

  test "should update volunteer_tagging" do
    patch volunteer_tagging_url(@volunteer_tagging), params: { volunteer_tagging: { organization_id: @volunteer_tagging.organization_id, volunteer_id: @volunteer_tagging.volunteer_id, volunteer_tag_id: @volunteer_tagging.volunteer_tag_id } }
    assert_redirected_to volunteer_tagging_url(@volunteer_tagging)
  end

  test "should destroy volunteer_tagging" do
    assert_difference('VolunteerTagging.count', -1) do
      delete volunteer_tagging_url(@volunteer_tagging)
    end

    assert_redirected_to volunteer_taggings_url
  end
end
