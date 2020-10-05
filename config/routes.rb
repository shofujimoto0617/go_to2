Rails.application.routes.draw do
  devise_for :users
  root 'homes#top'
  get 'search' => 'searches#search'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users, only: [:show, :edit, :update] do
  	member do
  		get :following, :followers
  	end
  end
  get 'users_country/:id' => 'users#show_country', as: 'country'
  resources :posts do
  	resources :post_comments, only: [:new, :create, :destroy]
  	resource :favorites, only: [:create, :destroy]
  end
  resources :direct_messages, only: [:create]
  resources :rooms, only: [:create, :show, :index]
  post 'follow/:id' => 'relationships#follow', as: 'follow'
  post 'unfollow/:id' => 'relationships#unfollow', as: 'unfollow'
end
