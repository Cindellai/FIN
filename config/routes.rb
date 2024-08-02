Rails.application.routes.draw do
  get 'home/index'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  # Root route
  root 'home#index'

  resources :users, only: [:show, :index]
  resources :posts, only: [:new, :create, :show, :edit, :update, :destroy]
  resources :subscriptions
  resources :trades
  resources :comments
end
