require 'rails_helper'

RSpec.describe YoutubeVideosController, type: :controller do

  let(:youtube_video) { FactoryGirl.create(:youtube_video) }
  let(:youtube_video_params) { FactoryGirl.attributes_for(:youtube_video) }

  context 'ログインしていない' do

    it 'newはログインページヘリダイレクトされる' do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it 'showは通常通り表示される' do
      get :show, params: { id: youtube_video.id }
      expect(response).to render_template :show
    end

    it 'createはログインページヘリダイレクトされる' do
      post :create
      expect(response).to redirect_to new_user_session_path
    end

    it 'editはログインページヘリダイレクトされる' do
      get :edit, params: { id: youtube_video.id }
      expect(response).to redirect_to new_user_session_path
    end

    it 'updateはログインページヘリダイレクトされる' do
      put :update, params: { id: youtube_video.id }
      expect(response).to redirect_to new_user_session_path
    end

    it 'destroyはログインページヘリダイレクトされる' do
      get :destroy, params: { id: youtube_video.id }
      expect(response).to redirect_to new_user_session_path
    end

  end

  context 'level1でログイン中' do

    let!(:user) { FactoryGirl.create(:user_level1) }

    before(:each) do
      sign_in user
    end

    it 'newはトップページへリダイレクトされる' do
      get :new
      expect(response).to redirect_to root_path
    end

    it 'showは通常通り表示される' do
      get :show, params: { id: youtube_video.id }
      expect(response).to render_template :show
    end

    it 'createはトップページヘリダイレクトされる' do
      post :create, params: { youtube_video: youtube_video_params }
      expect(response).to redirect_to root_path
    end

    it 'editはトップページヘリダイレクトされる' do
      get :edit, params: { id: youtube_video.id }
      expect(response).to redirect_to root_path
    end

    it 'updateはトップページヘリダイレクトされる' do
      put :update, params: { id: youtube_video.id }
      expect(response).to redirect_to root_path
    end

    it 'destroyはトップページヘリダイレクトされる' do
      get :destroy, params: { id: youtube_video.id }
      expect(response).to redirect_to root_path
    end


  end

  context 'level2でログイン中' do

    let!(:user) { FactoryGirl.create(:user_level2) }

    before(:each) do
      sign_in user
    end

    it 'newは新規作成画面が表示される' do
      get :new
      expect(response).to render_template :new
    end

    it 'showは通常どおり表示される' do
      get :show, params: { id: youtube_video.id }
      expect(response).to render_template :show
    end

  end

end
