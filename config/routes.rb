Rails.application.routes.draw do
  devise_for :users
  resources :bits, only: [:index] do
    collection do
      get :Search
    end
  end
  resources :youtube_videos, only: [:new, :create, :edit, :update, :show]
  resources :comments, only: [:create] do
    collection do
      post :reply
    end
  end
  root 'bits#index'
end
