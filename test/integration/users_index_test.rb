require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @admin = users(:first_user)
    @non_admin = users(:second_user)
  end

  test "index including pagination" do
    log_in_as(@admin)
    get users_path
    assert @admin.admin?
    assert_template 'users/index'
    assert_select 'div.pagination'
    assert_select 'ul.pagination', count: 2
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
      assert_response :see_other
      assert_redirected_to users_url
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
    assert_no_difference 'User.count' do
      delete user_path(@admin)
      assert_response :see_other
      assert_redirected_to root_url
    end
  end
end
  
  
  