Rails.application.routes.draw do
  get 'home/index'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root 'home#index'

  resources :users, only: [:index, :show, :edit, :update]
  resources :posts, only: [:new, :create, :edit, :update, :show, :index, :destroy]
  resources :subscriptions
  resources :trades
  resources :comments

  get 'users/:id', to: 'users#show', as: 'user_profile'
  get 'feed', to: 'users#feed', as: 'user_feed'
end
