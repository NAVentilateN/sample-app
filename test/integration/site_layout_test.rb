require "test_helper"

class SiteLayoutTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  test "layout links" do
    get root_path
    assert_response :success
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    # assert_select "a[href=?]", sign_in_path
    # assert_select "a[href=?]", sign_up_path
    assert_select "a[href=?]", help_path
    get '/help'
    assert_response :success
    assert_template 'static_pages/help'
    assert_select "title", full_title("Help")
    assert_select "a[href=?]", about_path, count: 2
    get '/about'
    assert_response :success
    assert_template 'static_pages/about'
    assert_select "title", full_title("About")
    assert_select "a[href=?]", contact_path, count: 2
    get '/contact'
    assert_response :success
    assert_template 'static_pages/contact'
    assert_select "title", full_title("Contact")
  end
end
