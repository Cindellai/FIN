Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  
  resources :subscriptions
  resources :trades
  resources :posts
  resources :comments

  root to: 'home#index'
end
