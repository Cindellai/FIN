Rails.application.routes.draw do
  get 'home/index'
  devise_for :users, controllers: {
    registrations: 'registrations',
    sessions: 'sessions'
  }

  root 'home#index'

  resources :users, only: [:show, :edit, :update] do
    member do
      patch :set_creator_role
    end
    resources :posts, only: [:new, :create, :edit, :update, :destroy]
  end

  resources :subscriptions
  resources :trades
  resources :comments

  get 'feed', to: 'users#feed', as: 'user_feed'
end
