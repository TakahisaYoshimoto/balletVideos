Rails.application.routes.draw do
  devise_for :users
  resources :bits, only: [:index] do
    collection do
      get :Search
      get :genreSearch
      get :nogenreSearch
      get :attentionSearch
    end
  end
  resources :youtube_videos, only: [:new, :create, :edit, :update, :show, :destroy]
  resources :comments, only: [:create] do
    collection do
      post :reply
    end
  end
  resources :top_tag_lists, only: [:index, :new, :create, :edit, :update, :show, :destroy]
  root 'bits#index'
end
