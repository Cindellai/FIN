Rails.application.routes.draw do
  get 'news/index'
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

  resources :posts, only: [:show, :index] do
    resources :comments, only: [:create, :destroy]
  end

  resources :subscriptions
  resources :trades

  get 'feed', to: 'users#feed', as: 'user_feed'

  # Add a route for the news page
  get 'news', to: 'news#index', as: 'news_page'
  get 'discover', to: 'discover#index', as: 'discover_page'
end
