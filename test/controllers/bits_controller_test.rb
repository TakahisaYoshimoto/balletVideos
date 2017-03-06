require 'test_helper'

class BitsControllerTest < ActionDispatch::IntegrationTest

  test "index" do
    get bits_path
    assert_response :success
    assert_equal 11, assigns(:youtubes).count
  end

  test "all" do
    get all_bits_path
    assert_response :success
    assert_equal 12, assigns(:youtubes).count

    get all_bits_path, { page: 5 }
    assert_response :success
    assert_equal 2, assigns(:youtubes).count, '5ページ目は2件だけ'
  end

end
