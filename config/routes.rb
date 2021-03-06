Rails.application.routes.draw do
  use_doorkeeper do
    skip_controllers :authorizations, :applications, :authorized_applications
  end
  # devise_for :users

  resources :users, only: %i[create profile] do
    get :profile, on: :collection
    get :user_statistics, on: :collection
    put :update_profile, on: :collection
  end

  # Defines the root path route ("/")
  root "posts#index"

  resources :posts do
    get :search, on: :collection
  end

  resources :post_links, only: :post do
  end

  get '/post_link' => 'post_links#post'

  resources :bids, only: %i[create update destroy open_post_bids] do
    get :open_post_bids, on: :collection
    put :accept_bid, on: :collection
  end

  resources :rejected_bids, only: []

  resources :accepted_bids, only: []

  resources :notifications, only: %i[all_notifications mark_read] do
    get :all_notifications, on: :collection
    put :mark_read, on: :collection
  end

  mount ActionCable.server => '/cable'

end
