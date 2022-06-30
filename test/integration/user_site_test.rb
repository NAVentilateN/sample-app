require "test_helper"

class UserSiteTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @user = users(:first_user)
    @user.password = ("foobar")
    @user.password_confirmation = ("foobar")
    @user2 = users(:second_user)
    @user2.password = ("foobar")
    @user2.password_confirmation = ("foobar")
  end
  
   test "users links" do
     @user.save
     
     get users_path
     assert_response :success
     
     get user_path(@user)
     assert_response :success
     
     get edit_user_path(@user)
     assert_response :success
   end
end
