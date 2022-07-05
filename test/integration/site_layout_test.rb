require "test_helper"

class SiteLayoutTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @user = users(:first_user)
    @user2 = users(:second_user)
  end
  
  test "logged out layout links" do
    get root_path
    assert_response :success
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    # assert_select "a[href=?]", sign_in_path
    assert_select "a[href=?]", signup_path
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path, count: 2
    assert_select "a[href=?]", contact_path, count: 2
    
    get signup_path
    assert_response :success
    assert_select "title", full_title("Sign up")
    
    get help_path
    assert_response :success
    assert_template 'static_pages/help'
    assert_select "title", full_title("Help")
    
    get about_path
    assert_response :success
    assert_template 'static_pages/about'
    assert_select "title", full_title("About")
    
    get contact_path
    assert_response :success
    assert_template 'static_pages/contact'
    assert_select "title", full_title("Contact")
  end
  
  test "logged in layout links" do
    log_in_as(@user)
    get root_path
    assert_response :success
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    # # assert_select "a[href=?]", sign_in_path
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path, count: 2
    assert_select "a[href=?]", contact_path, count: 2
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", edit_user_path(@user)
    assert_select "a[href=?]", logout_path
    
    get users_path
    assert_response :success
    assert_template 'users/index'
    assert_select "title", full_title("All users")
    
    get user_path(@user)
    assert_response :success
    assert_template 'users/show'
    assert_select "title", full_title(@user.name)
    
    get edit_user_path(@user)
    assert_response :success
    assert_template 'users/edit'
    assert_select "title", full_title("Edit user")
  end
end
