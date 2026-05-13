# frozen_string_literal: true

Rails.application.routes.draw do
  get 'static/terms'
  get 'static/privacy'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  get '/users/auth/google_oauth2', to: redirect('/auth/google_oauth2')
  resources :posts, param: :uuid do
    resource :like, only: %i[create destroy]
    resources :comments, only: %i[create destroy]
  end

  resources :tags, only: [:show], param: :name

  resources :relationships, only: %i[create destroy]
  resources :users, only: [:show] do
    member do
      get :following
      get :followers
      get :likes
    end
  end

  get 'terms',   to: 'static#terms'
  get 'privacy', to: 'static#privacy'

  root 'home#index'
  get 'up' => 'rails/health#show', as: :rails_health_check
end
