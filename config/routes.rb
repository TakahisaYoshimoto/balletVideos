Rails.application.routes.draw do
  devise_for :users
  resources :bits do
    collection do
      get :Search
    end
  end
  resources :youtube_videos
  resources :comments
  root 'bits#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
