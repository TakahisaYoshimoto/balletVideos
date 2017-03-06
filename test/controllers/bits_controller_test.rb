require 'test_helper'

class BitsControllerTest < ActionDispatch::IntegrationTest

  test "index" do
    get bits_path
    assert_response :success
    assert_equal 11, assigns(:youtubes).count
    assert_select '.y_video_img_area', assigns(:youtubes).count

    assert_equal 2, assigns(:pic_youtubes).count
    assert_includes assigns(:pic_youtubes), youtube_videos(:pickup_level1)
    assert_includes assigns(:pic_youtubes), youtube_videos(:pickup_level2)
    assert_select '.y_index_links_pickup_area', 2
  end

  test "all" do
    get all_bits_path
    assert_response :success
    assert_equal 12, assigns(:youtubes).count
    assert_select '.y_video_img_area', assigns(:youtubes).count

    get all_bits_path, params: { page: 5 }
    assert_response :success
    assert_equal YoutubeVideo.count % 12, assigns(:youtubes).count, '最後のページは12で割った余り'
    assert_select '.y_video_img_area', assigns(:youtubes).count

    get all_bits_path, params: { page: 6 }
    assert_response :success
    assert_equal 0, assigns(:youtubes).count
    assert_select '.y_video_img_area', 0
  end

  test "allのページネーション" do
    get all_bits_path
    assert_select '.pagination > li', 7
    assert_select '.pagination > li.active:first-child'

    get all_bits_path, params: { page: 3 }
    assert_select '.pagination > li', 9
    assert_select '.pagination > li.active:nth-child(5)'

    get all_bits_path, params: { page: 5 }
    assert_select '.pagination > li', 7
    assert_select '.pagination > li.active:last-child'
  end

end
