require 'test_helper'

class TopTagListTest < ActiveSupport::TestCase

  test "必須項目のテスト" do
    top_tag_list = TopTagList.new
    assert_not top_tag_list.save
    top_tag_list.tag_name = "tag"
    assert_not top_tag_list.save
    top_tag_list.hurigana = "タグ"
    assert top_tag_list.save
  end

end
