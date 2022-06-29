require "test_helper"

class UserControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
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

  test "should get edit" do
    get user_edit_url
    assert_response :success
  end

  # test "should get update" do
  #   get user_update_url
  #   assert_response :success
  # end

  test "should get all" do
    get user_all_url
    assert_response :success
  end

  test "should get show" do
    get user_show_url
    assert_response :success
  end

  # test "should get destroy" do
  #   get user_destroy_url
  #   assert_response :success
  # end
end
