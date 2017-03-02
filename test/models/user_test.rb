require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "likeが一緒に消えるテスト" do
    user = users(:level1)
    assert_not_equal 0 , Like.where(user_id: user.id).count
    user.destroy
    assert_equal 0 , Like.where(user_id: user.id).count
  end

end
