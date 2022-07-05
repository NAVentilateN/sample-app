require "test_helper"

class UserControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
    @user = users(:first_user)
    @user_2 = users(:second_user)
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
  test "should redirect index if not logged in" do
    get users_path
    assert_response :redirect
    assert_redirected_to login_url
  end
  
  test "should redirect edit if not logged in" do
    get edit_user_path(@user)
    assert_response :redirect
    assert_redirected_to login_url
  end
  
  test "should redirect edit if logged in as another user" do
    log_in_as(@user)
    get edit_user_path(@user_2)
    assert_response :redirect
    assert_redirected_to root_path
  end
  
  test "should redirect update if not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_response :redirect
    assert_redirected_to login_url
  end

  test "successful getting to edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    assert_response :redirect
  end

  # test "should get update" do
  #   get user_update_url
  #   assert_response :success
  # end

  test "successful getting to index with friendly forwarding" do
    get users_path
    log_in_as(@user)
    assert_redirected_to users_path
    assert_response :redirect
  end

  test "should get show" do
    get user_path(@user)
    assert_response :success
  end
  
  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@user_2)
    assert_not @user_2.admin?
    patch user_path(@user_2), params: {
                                    user: { password:              "password",
                                            password_confirmation: "password",
                                            admin: true } }
    assert_not @user_2.reload.admin?
  end
  
  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_response :see_other
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@user_2)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_response :see_other
    assert_redirected_to root_url
  end

  # test "should get destroy" do
  #   @user.save
  #   assert_difference User.count, -1 do
  #     delete user_path(@user)
  #   end
  # end
end
