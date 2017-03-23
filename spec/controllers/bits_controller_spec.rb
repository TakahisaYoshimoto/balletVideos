require 'rails_helper'

RSpec.describe BitsController, type: :controller do

  before(:each) do
    YoutubeVideo.destroy_all
  end

  describe 'index' do

    context '@youtubes' do

      it '最大で11まで' do
        FactoryGirl.create_list(:youtube_video, 1)
        get :index
        expect(assigns(:youtubes).count).to eq(1)

        FactoryGirl.create_list(:youtube_video, 10)
        get :index
        expect(assigns(:youtubes).count).to eq(11)

        FactoryGirl.create_list(:youtube_video, 1)
        get :index
        expect(assigns(:youtubes).count).to eq(11)
      end

      it 'pickup_levelが1と2は対象外' do
        FactoryGirl.create(:youtube_video, pickup_level: 1)
        FactoryGirl.create(:youtube_video, pickup_level: 2)
        get :index
        youtubes = assigns(:youtubes)
        expect(youtubes.count).to eq(0)
      end

      it 'pickup_levelがnullと3以上は対象' do
        FactoryGirl.create(:youtube_video)
        FactoryGirl.create(:youtube_video, pickup_level: 3)
        get :index
        youtubes = assigns(:youtubes)
        expect(youtubes.count).to eq(2)
      end

    end

    context '@pic_youtubes' do

      it 'level1、2がない' do
        get :index
        expect(assigns(:pic_youtubes).count).to eq(0)
      end

      it 'level1が1個のときは1番目にlevel1' do
        FactoryGirl.create(:youtube_video, pickup_level: 1)
        get :index
        pic_youtubes = assigns(:pic_youtubes)
        expect(pic_youtubes.count).to eq(1)
        expect(pic_youtubes[0].pickup_level).to eq(1)
      end

      it 'level2が1個のときは1番目にlevel2' do
        FactoryGirl.create(:youtube_video, pickup_level: 2)
        get :index
        pic_youtubes = assigns(:pic_youtubes)
        expect(pic_youtubes.count).to eq(1)
        expect(pic_youtubes[0].pickup_level).to eq(2)
      end

      it 'level1とlevel2のときは、1→2の順番' do
        FactoryGirl.create(:youtube_video, pickup_level: 1)
        FactoryGirl.create(:youtube_video, pickup_level: 2)
        get :index
        pic_youtubes = assigns(:pic_youtubes)
        expect(pic_youtubes.count).to eq(2)
        expect(pic_youtubes[0].pickup_level).to eq(1)
        expect(pic_youtubes[1].pickup_level).to eq(2)
      end

      it 'level1が2個以上の時は両方level1' do
        FactoryGirl.create(:youtube_video, pickup_level: 1)
        FactoryGirl.create(:youtube_video, pickup_level: 1)
        FactoryGirl.create(:youtube_video, pickup_level: 2)
        get :index
        pic_youtubes = assigns(:pic_youtubes)
        expect(pic_youtubes[0].pickup_level).to eq(1)
        expect(pic_youtubes[1].pickup_level).to eq(1)
      end

    end

  end

  describe 'all' do

    it '1ページ最大件数' do
      per_page = YoutubeVideo.default_per_page
      FactoryGirl.create_list(:youtube_video, per_page)
      get :all
      expect(assigns(:youtubes).count).to eq(per_page)

      FactoryGirl.create_list(:youtube_video, 1)
      get :all
      expect(assigns(:youtubes).count).to eq(per_page)
    end

    it '2ページ以上あるとき' do
      per_page = YoutubeVideo.default_per_page
      FactoryGirl.create_list(:youtube_video, per_page + 1)
      get :all, params: { page: 2 }
      expect(assigns(:youtubes).count).to eq(1)
    end

    it 'ソート順の指定がないときは新着順' do
      now = Time.now
      FactoryGirl.create(:youtube_video, created_at: now - 1000)
      FactoryGirl.create(:youtube_video, created_at: now)
      FactoryGirl.create(:youtube_video, created_at: now - 500)
      get :all
      youtubes = assigns(:youtubes)
      expect(youtubes[0].created_at).to be_within(1.minutes).of(now)
      expect(youtubes[1].created_at).to be_within(1.minutes).of(now - 500)
      expect(youtubes[2].created_at).to be_within(1.minutes).of(now - 1000)
    end

    it '再生回数順' do
      FactoryGirl.create(:youtube_video, pv_count: 7)
      FactoryGirl.create(:youtube_video, pv_count: 2)
      FactoryGirl.create(:youtube_video, pv_count: 10)
      get :all, params: { or: 'pv' }
      youtubes = assigns(:youtubes)
      expect(youtubes[0].pv_count).to eq(10)
      expect(youtubes[1].pv_count).to eq(7)
      expect(youtubes[2].pv_count).to eq(2)
    end

  end

  describe 'search' do

    describe 'タイトルを検索' do

      it 'キーワードが空はallへリダイレクト' do
        get :Search
        expect(response).to redirect_to all_bits_path
      end

      it 'タイトルを部分一致で検索できる' do
        FactoryGirl.create(:youtube_video, title: 'title')

        get :Search, params: { search_params: 'title' }
        expect(assigns(:youtubes).count).to eq(1)

        get :Search, params: { search_params: 'tit' }
        expect(assigns(:youtubes).count).to eq(1)

        get :Search, params: { search_params: 'tl' }
        expect(assigns(:youtubes).count).to eq(1)

        get :Search, params: { search_params: 'tle' }
        expect(assigns(:youtubes).count).to eq(1)
      end

      it 'タイトルを大文字小文字区別せずに検索できる' do
        FactoryGirl.create(:youtube_video, title: 'title')

        get :Search, params: { search_params: 'tit' }
        expect(assigns(:youtubes).count).to eq(1)

        get :Search, params: { search_params: 'TIT' }
        expect(assigns(:youtubes).count).to eq(1)
      end

      it 'タイトルに引っかからない検索' do
        FactoryGirl.create(:youtube_video, title: 'title')

        get :Search, params: { search_params: 'titleeee' }
        expect(assigns(:youtubes).count).to eq(0)

        get :Search, params: { search_params: 'foo' }
        expect(assigns(:youtubes).count).to eq(0)
      end

      it 'スペース区切りでAND検索' do
        FactoryGirl.create(:youtube_video, title: 'これは動画のタイトルです')

        get :Search, params: { search_params: '動画 タイトル' }
        expect(assigns(:youtubes).count).to eq(1)

        get :Search, params: { search_params: ' 動画 タイトル ' }
        expect(assigns(:youtubes).count).to eq(1)

        get :Search, params: { search_params: '　動画　タイトル　' }
        expect(assigns(:youtubes).count).to eq(1), '全角スペース区切り'

        get :Search, params: { search_params: '動画 あいうえお' }
        expect(assigns(:youtubes).count).to eq(0)
      end

    end

  end

end
