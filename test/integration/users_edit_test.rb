require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:first_user)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              first_name: "",
                                              last_name: "",
                                              password:              "foo",
                                              password_confirmation: "bar" } }

    assert_template 'users/edit'
    assert_select "div#error_explanation ul li", 6
  end
  
  
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    follow_redirect!
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name:  "test_test",
                                              email: "foo@valid.com",
                                              first_name: "foo",
                                              last_name: "foo",
                                              password:              "foobar",
                                              password_confirmation: "foobar" } }
  assert_not flash.empty?
  assert_response :redirect
  assert_redirected_to @user
  follow_redirect!
  @user.reload
  assert_template 'users/show'
  
  assert_equal "test_test", @user.name
  assert_equal "foo@valid.com", @user.email
  end
end