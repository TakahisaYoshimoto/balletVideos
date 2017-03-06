require 'test_helper'

class BitsControllerTest < ActionDispatch::IntegrationTest

  test "index" do
    get bits_path
    assert_response :success
    assert_equal 11, assigns(:youtubes).count

    assert_equal 2, assigns(:pic_youtubes).count
    assert_includes assigns(:pic_youtubes), youtube_videos(:pickup_level1)
    assert_includes assigns(:pic_youtubes), youtube_videos(:pickup_level2)
  end

  test "all" do
    get all_bits_path
    assert_response :success
    assert_equal 12, assigns(:youtubes).count

    get all_bits_path, params: { page: 5 }
    assert_response :success
    assert_equal YoutubeVideo.count % 12, assigns(:youtubes).count, '最後のページは12で割った余り'
  end

end
