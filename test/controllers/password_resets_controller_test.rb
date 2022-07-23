require "test_helper"

class PasswordResetsControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = User.first
  end
  
  test "should get new" do
    get new_password_reset_path
    assert_response :success
  end

  test "should get edit" do
    # get edit_password_reset_path(@user.reset_top)
    # assert_response :success
  end
end
