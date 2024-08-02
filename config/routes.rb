Rails.application.routes.draw do
  get 'home/index'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

   # Define a route for the user profile page
   get 'users/:id', to: 'users#show', as: 'user_profile'
  
  resources :subscriptions
  resources :trades
  resources :posts
  resources :comments

  root to: 'home#index'
end
