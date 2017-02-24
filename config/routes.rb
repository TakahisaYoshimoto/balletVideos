Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  resources :bits, only: [:index] do
    collection do
      get :all
      get :Search
      get :genreSearch
      get :nogenreSearch
      get :attentionSearch
      get :sign_up_mail
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
  root 'bits#index'
end
