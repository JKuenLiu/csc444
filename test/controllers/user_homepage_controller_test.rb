require 'test_helper'

class UserHomepageControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_homepage_index_url
    assert_response :success
  end

end
