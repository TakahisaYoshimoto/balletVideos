Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  resources :bits, only: [:index] do
    collection do
      get :videotop
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
      get :terms
    end
  end
  resources :youtube_videos, only: [:new, :create, :edit, :update, :show, :destroy] do
    collection do
      get :like
      get :pickup_lists
    end
  end
  resources :comments, only: [:create] do
    collection do
      post :reply
    end
  end
  resources :top_tag_lists, only: [:index, :new, :create, :edit, :update, :show, :destroy]
  resources :site_configurations, only: [:index, :new, :create, :edit, :update, :show] do
    collection do
      get :user_lists
    end
  end
  resources :profiles, only: [:show]
  resources :boards, only: [:index, :new, :create, :edit, :update, :show, :destroy] do
    collection do
      get :Search
      get :my_post
      get :my_commented
      get :new_lists
      get :attention
      get :like
    end
  end
  resources :board_comments, only: [:create, :new, :destroy] do
    collection do
      get :display
    end
  end
  get 'profile_pictures/upload'
  post 'profile_pictures/upload_process'
  root 'bits#index'
end
