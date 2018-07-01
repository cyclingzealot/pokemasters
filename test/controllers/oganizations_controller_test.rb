require 'test_helper'

class OganizationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @oganization = oganizations(:one)
  end

  test "should get index" do
    get oganizations_url
    assert_response :success
  end

  test "should get new" do
    get new_oganization_url
    assert_response :success
  end

  test "should create oganization" do
    assert_difference('Oganization.count') do
      post oganizations_url, params: { oganization: { email: @oganization.email, enabled: @oganization.enabled, name: @oganization.name, web: @oganization.web } }
    end

    assert_redirected_to oganization_url(Oganization.last)
  end

  test "should show oganization" do
    get oganization_url(@oganization)
    assert_response :success
  end

  test "should get edit" do
    get edit_oganization_url(@oganization)
    assert_response :success
  end

  test "should update oganization" do
    patch oganization_url(@oganization), params: { oganization: { email: @oganization.email, enabled: @oganization.enabled, name: @oganization.name, web: @oganization.web } }
    assert_redirected_to oganization_url(@oganization)
  end

  test "should destroy oganization" do
    assert_difference('Oganization.count', -1) do
      delete oganization_url(@oganization)
    end

    assert_redirected_to oganizations_url
  end
end
