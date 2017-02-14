Rails.application.routes.draw do
  get 'top_tag_lists/index'

  get 'top_tag_lists/new'

  get 'top_tag_lists/edit'

  get 'top_tag_list/new'

  get 'top_tag_list/edit'

  get 'top_tag_list/show'

  devise_for :users
  resources :bits, only: [:index] do
    collection do
      get :Search
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
