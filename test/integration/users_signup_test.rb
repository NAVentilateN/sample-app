require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_response :unprocessable_entity
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
  end
  
  
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
    assert_template 'users/show'
    assert_select 'div.alert-success'
    assert_select 'img.gravatar'
    
    get @user
    assert_select 'div.alert-success', 0
  end
end
