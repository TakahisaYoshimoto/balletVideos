require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "likeが一緒に消えるテスト" do
    total_like_count = Like.count
    root = users(:root)
    root_like_count = root.likes.count
    assert_equal 2, root_like_count
    assert_equal total_like_count, Like.count, "消す前"
    root.destroy
    assert_equal total_like_count - root_like_count, Like.count, "消した後"
  end

end
