require "test_helper"

class RelationshipTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @relationship = Relationship.new(follower_id: users(:first_user).id,
                                     followed_id: users(:second_user).id)
  end

  test "should be valid" do
    assert @relationship.valid?
  end

  test "should require a follower_id" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test "should require a followed_id" do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end
  
  test "should follow and unfollow a user" do
    first_user = users(:first_user)
    second_user = users(:second_user)
    
    assert_not first_user.following?(second_user)
    first_user.follow(second_user)
    assert first_user.following?(second_user)
    assert second_user.followers.include?(first_user)
    first_user.unfollow(second_user)
    assert_not first_user.following?(second_user)
    assert_not second_user.followers.include?(first_user)
  end
    
  # test "follower and followed should not be the same" do
  #   @relationship.followed_id = users(:first_user).id
  #   assert_not @relationship.valid?
  # end
end
