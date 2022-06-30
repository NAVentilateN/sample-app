require "test_helper"

class UserControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
    @user = users(:first_user)
    @user.password = "foobar"
    @user.password_confirmation = "foobar"
  end
  
  test "should get new" do
    get signup_url
    assert_response :success
    assert_select "title", "Sign up | #{@base_title}"
  end

  # test "should get create" do
  #   get user_create_url
  #   assert_response :success
  # end

  test "should get edit page" do
    @user.save
    get edit_user_path(@user)
    assert_response :success
  end

  # test "should get update" do
  #   get user_update_url
  #   assert_response :success
  # end

  test "should get all" do
    get users_path
    assert_response :success
  end

  test "should get show" do
    @user.save
    get user_path(@user)
    assert_response :success
  end

  # test "should get destroy" do
  #   @user.save
  #   assert_difference User.count, -1 do
  #     delete user_path(@user)
  #   end
  # end
end
