require 'test_helper'

class TopTagListsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get top_tag_lists_index_url
    assert_response :success
  end

  test "should get new" do
    get top_tag_lists_new_url
    assert_response :success
  end

  test "should get edit" do
    get top_tag_lists_edit_url
    assert_response :success
  end

end
