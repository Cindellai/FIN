Rails.application.routes.draw do
  get 'home/index'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  # Root route
  root 'home#index'

  resources :users, only: [:show, :index]
  resources :posts
  resources :subscriptions
  resources :trades
  resources :comments

  get 'users/:id', to: 'users#show', as: 'user_profile'
  get 'feed', to: 'users#feed', as: 'user_feed'

end
