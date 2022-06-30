require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @user = users(:first_user)
    @user2 = users(:second_user)
  end
  
  test "invalid user if name is empty" do
    @user.name = ""
    assert_not @user.valid?
  end
  
  test "invalid user if email is empty" do
    @user.email = ""
    assert_not @user.valid?
  end
  
  test "invalid user if first name is empty" do
    @user.first_name = ""
    assert_not @user.valid?
  end
  
  test "invalid user if last name is empty" do
    @user.last_name = ""
    assert_not @user.valid?
  end
  
  test "valid user if all fields are not empty and email format is correct" do
    assert @user.valid?
  end
  
  test "invalid user if all user name is more than 20 character long" do
    @user.name = "a"*21
    assert_not @user.valid?
  end
  
  test "invalid user if all username is already taken" do
    @user.save
    @user2.name = 'first'
    assert_not @user2.valid?
  end
  
   test "invalid user if all user email is already taken" do
    @user.save
    @user2.email = 'first@first.com'
    assert_not @user2.valid?
  end
  
  test "invalid user if all user email format is incorrect" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar/baz.com foo@bar+baz.com]
                           
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  
  
  test "user email should be downcase after saving into database" do
    email = "FiRsT@FiRsT.com"
    @user.email = email
    @user.save
    assert_not_equal @user.email, email
    assert_equal @user.email, email.downcase
  end
end
