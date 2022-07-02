require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:first_user)
    @user2 = users(:second_user)
  end
  
  test "should get new" do
    get login_path
    assert_response :success
    assert_template "sessions/new"
    assert_select "title", full_title("Login")
  end
end
