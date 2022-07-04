require "test_helper"

class SessionsHelperTest < ActionView::TestCase
# Define a user variable using the fixtures.
# Call the remember method to remember the given user.
  def setup
    @user = users(:first_user)
    remember(@user)
  end

# Verify that current_user is equal to the given user.
  test "current_user returns right user when session is nil" do
    # when current user is called, it is not calling an object "current_user"
    # it is calling the method current user to be run and at the end
    # it will return the instance var @current_user as an output for comparison
    assert_equal @user, current_user
    assert is_logged_in?
  end

# Verify that authenticate method only works if the cookie is the same
# this change the current cookie of the user simulating a new session
# since user remember token is not the same as the device cookie token
# authentication will fail and current user will not be fully execute.
  test "current_user returns nil when remember digest is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end
end