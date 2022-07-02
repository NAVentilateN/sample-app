require "test_helper"

class UserSiteTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @user = users(:first_user)
    @user2 = users(:second_user)
  end
  
   test "users links" do

     get users_path
     assert_response :success 
     
    # get user_path(@user)
    # assert_response :success
    # assert_template "users/show"
     
    # get edit_user_path(@user)
    # assert_response :success
    # assert_template "users/edit"
   end
end
