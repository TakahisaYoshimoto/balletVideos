require 'test_helper'

class BitsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get bits_index_url
    assert_response :success
  end

  test "should get show" do
    get bits_show_url
    assert_response :success
  end

  test "should get new" do
    get bits_new_url
    assert_response :success
  end

  test "should get edit" do
    get bits_edit_url
    assert_response :success
  end

end
