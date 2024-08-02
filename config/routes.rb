Rails.application.routes.draw do
  get 'home/index'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  
  # Root route
  root 'home#index'

   # Define a route for the user profile page
   get 'users/:id', to: 'users#show', as: 'user_profile'
  
  resources :subscriptions
  resources :trades
  resources :posts
  resources :comments
  resources :users, only: [:show, :index] 
end
