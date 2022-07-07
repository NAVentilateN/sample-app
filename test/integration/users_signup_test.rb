require "test_helper"

class UsersSignup < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    ActionMailer::Base.deliveries.clear
    get signup_path
  end
end

class InvalidSignupTest < UsersSignup

  test "invalid signup information" do
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_response :unprocessable_entity
    assert_template 'users/new'
    assert_select "div#error_explanation ul li", 6
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
  end
end
  
class ValidSignupTest < UsersSignup
  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "validUser",
                                         first_name: "valid",
                                         last_name: "user",
                                         email: "user@valid.com",
                                         password:              "foobar",
                                         password_confirmation: "foobar" } }
    end
    assert_response :redirect
    follow_redirect!
    assert root_url
    assert_not is_logged_in?
    assert_equal 1, ActionMailer::Base.deliveries.size
    # assert is_logged_in?
    # assert_template 'users/show'
    # assert_select 'div.alert-success'
    # assert_select 'img.gravatar'
    
    # get @user
    # assert_select 'div.alert-success', 0
    @user = assigns(:user)
  end
end

class AccountActivationTest < UsersSignup
  
  def setup
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "validUser",
                                         first_name: "valid",
                                         last_name: "user",
                                         email: "user@valid.com",
                                         password:              "foobar",
                                         password_confirmation: "foobar" } }
    end
    
    @user = assigns(:user)
  end
  
  test "should not be activated" do
    assert_not @user.activated?
  end

  test "should not be able to log in before account activation" do
    log_in_as(@user)
    assert_not is_logged_in?
  end

  test "should not be able to log in with invalid activation token" do
    get edit_account_activation_path("invalid token", email: @user.email)
    assert_not is_logged_in?
  end

  test "should not be able to log in with invalid email" do
    get edit_account_activation_path(@user.activation_token, email: 'wrong')
    assert_not is_logged_in?
  end

  test "should log in successfully with valid activation token and email" do
    get edit_account_activation_path(@user.activation_token, email: @user.email)
    assert @user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end