require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @user = User.new(name: "test", 
                     first_name: "test", 
                     last_name: "test", 
                     email: "test@test.com", 
                     password: "foobar",
                     password_confirmation: "foobar")
                     
    @user2 = User.new(name: "test2", 
                     first_name: "test2", 
                     last_name: "test2", 
                     email: "test2@test.com", 
                     password: "foobar",
                     password_confirmation: "foobar")
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
  
  test "valid user if all fields are not empty and email format is correct and user is able to create a new account" do
    assert @user.valid?
    @user.save
    assert @user.authenticate('foobar')
  end
  
  test "invalid user if all user name is more than 50 character long" do
    @user.name = "a"*51
    assert_not @user.valid?
  end
  
  test "invalid user if all username is already taken" do
    @user.save
    @user2.name = 'first'
    assert_not @user2.valid?
  end
  
   test "invalid user if all user email is already taken" do
    @user.save
    @user2.email = @user.email
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
  
  
  test "user email should not be the same after saving into database" do
    email = "tEsT@tEsT.com"
    @user.email = email
    @user.save
    assert_not_equal @user.email, email
  end
  
  test "user email should be downcase after saving into database" do
    email = "tEsT@tEsT.com"
    @user.email = email
    @user.save
    assert_equal @user.email, email.downcase
  end
  
  test "user password should not be blank" do
    @user.password = " " * 6
    assert_not @user.valid?
  end
  
  test "user password should not be less than 6 character" do
    @user.password = "a" * 5
    assert_not @user.valid?
  end
  
  test "authenticate? method should return false if remember digest is nil" do
    assert_not @user.authenticate?(:remember,"")
  end
  
  test "remember function generate remember_digest for user" do
    @user.remember
    assert_not_nil @user.remember_digest
  end
  
  test "forget function forget remember_digest for user" do
    @user.remember
    @user.forget
    assert_nil @user.remember_digest
  end
  
  test "session_token generate a new token for user" do
    assert_nil @user.remember_digest
    @user.session_token
    assert_not_nil @user.remember_digest
  end
  
  test "session_token does not generate a new token for user when remember_digest exist" do
    token_1 = @user.session_token
    assert_equal token_1, @user.session_token
  end
  
  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end
  
  test "feed should have the right posts" do
    first = users(:first_user)
    second  = users(:second_user)
    third    = users(:third_user)
    # Posts from followed user
    third.microposts.each do |post_following|
      assert first.feed.include?(post_following)
    end
    # Self-posts for user with followers
    first.microposts.each do |post_self|
      assert first.feed.include?(post_self)
      assert_equal first.feed.distinct, first.feed
    end
    # Posts from non-followed user
    second.microposts.each do |post_unfollowed|
      assert_not first.feed.include?(post_unfollowed)
    end
  end
end
