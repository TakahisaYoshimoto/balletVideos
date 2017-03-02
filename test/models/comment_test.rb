require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  test "必須項目のテスト" do
    comment = users(:level1).comments.build
    assert_not comment.save
    comment.text = "foo"
    assert comment.save
  end

  test "コメント最大文字数のテスト" do
    comment = users(:level1).comments.build
    comment.text = "a" * 402
    assert_not comment.save
    comment.text = "a" * 401
    assert comment.save
  end

end
