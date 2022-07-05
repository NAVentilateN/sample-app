require "test_helper"

class UserSiteTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @user = users(:first_user)
    @user2 = users(:second_user)
  end
end
