Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  resources :bits, only: [:index] do
    collection do
      get :all
      get :like_videos
      get :view_histories
      get :Search
      get :genreSearch
      get :nogenreSearch
      get :attentionSearch
      get :sign_up_mail
      get :inquiry
      get :inquiry_after
      post :send_support_mail
      get :privacy_policy
      get :operation_information
    end
  end
  resources :youtube_videos, only: [:new, :create, :edit, :update, :show, :destroy] do
    collection do
      get :like
    end
  end
  resources :comments, only: [:create] do
    collection do
      post :reply
    end
  end
  resources :top_tag_lists, only: [:index, :new, :create, :edit, :update, :show, :destroy]
  resources :site_configurations, only: [:index, :new, :create, :edit, :update, :show]
  resources :profiles, only: [:show]
  get 'profile_pictures/upload'
  post 'profile_pictures/upload_process'
  root 'bits#index'
end
