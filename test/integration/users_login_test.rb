require "test_helper"

class UsersLogin < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @user = users(:first_user)
    @user_2 = users(:second_user)
  end
end

class InvalidPasswordTest < UsersLogin
  # in this test it inherit the set up of user
  test "login path" do
    get login_path
    assert_template 'sessions/new'
  end

  test "login with valid email/invalid password" do
    post login_path, params: { session: { email:    @user.email,
                                          password: "invalid" } }
    assert_not is_logged_in?
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
end


class ValidLogin < UsersLogin

  def setup
    super
    post login_path, params: { session: { email:    @user.email,
                                          password: 'foobar',
                                          remember_me: "1"} }
  end
end


# in the following test,
# the previous state of the test will persist throughout the following class. 
# This allow user to "breakdown" the steps into different class
class ValidLoginTest < ValidLogin

  test "valid login with remembering" do
    assert is_logged_in?
    assert_redirected_to @user
    assert_not_nil cookies[:remember_token]
  end

  test "redirect after login" do
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end
  
  test "log in with remembering" do
    assert_not_nil cookies[:remember_token]
  end
end

class Logout < ValidLogin

  def setup
    super
    delete logout_path
  end
end

class LogoutTest < Logout
  test "successful logout" do
    assert_not is_logged_in?
    assert_response :see_other
    assert_redirected_to root_url
    # simulate a second log out in another brower
    delete logout_path
  end
  
  test "redirect after logout" do
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
end

class RememberTest < UsersLogin

  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_equal cookies[:remember_token], assigns(:user).remember_token
  end

  test "login without remembering" do
    # Log in to set the cookie.
    log_in_as(@user, remember_me: '1')
    # Log in again and verify that the cookie is deleted.
    log_in_as(@user, remember_me: '0')
    assert cookies[:remember_token].blank?
  end
end 
#   test "invalid login" do
    
#     # Visit the login path.
#     get login_path
#     # Verify that the new sessions form renders properly.
#     assert_template 'sessions/new'
#     # Post to the sessions path with an invalid params hash.
#     # Verify that the new sessions form returns the right status code and gets re-rendered.
#     assert_no_difference 'User.count' do
#       post login_path, params: { session: { email:    "user@invalid.com",
#                                         password: "foo"          }}
#     end
#     assert_response :unprocessable_entity
#     # Verify that a flash message appears.
#     assert_template "sessions/new"
#     assert_not flash.empty?
#     # Visit another page (such as the Home page).
#     get root_path
#     # Verify that the flash message doesn’t appear on the new page.
#     assert flash.empty?
#   end
  
#   test "login with valid email/invalid password" do
#     get login_path
#     assert_template 'sessions/new'
#     post login_path, params: { session: { email:    @user.email,
#                                           password: "invalid" } }
#     assert_not is_logged_in?
#     assert_response :unprocessable_entity
#     assert_template 'sessions/new'
#     assert_not flash.empty?
#     get root_path
#     assert flash.empty?
#   end
  
#   test "valid login and log out" do
#     # Visit the login path.
#     get login_path
#     # Verify that the new sessions form renders properly.
#     assert_template 'sessions/new'
#     # Post to the sessions path with an valid params hash.
#     # Verify that the new sessions form returns the right status code and gets redirect to root path.
#     assert_no_difference 'User.count' do
#       post login_path, params: { session: { email:    @user.email,
#                                             password: "foobar"          }}
#     end
    
#     assert_response :redirect
#     follow_redirect!
#     assert is_logged_in?
#     # Verify that the correct template was render.
#     assert_template "static_pages/home"
#     assert_select 'a[href=?]', login_path, 0
#     assert_select 'a[href=?]', logout_path
#     assert_select 'a[href=?]', user_path(@user)
#     # Verify that the flash message doesn’t appear on the new page.
#     assert flash.empty?
#     delete logout_path
#     assert_not is_logged_in?
#     assert_response :see_other
#     assert_redirected_to root_url
#     follow_redirect!
#     assert_select "a[href=?]", login_path
#     assert_select "a[href=?]", logout_path,      count: 0
#     assert_select "a[href=?]", user_path(@user), count: 0
#   end
# end
