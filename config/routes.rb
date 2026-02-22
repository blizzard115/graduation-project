Rails.application.routes.draw do
  get 'static/terms'
  get 'static/privacy'
  devise_for :users

  resources :posts do
    resource :like, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
  end

  resources :users, only: [:show] do
    member do
      get :likes   # /users/:id/likes
    end
  end

  resources :tags, only: [:show], param: :name

  resources :relationships, only: [:create, :destroy]
  resources :users, only: [:show] do
    member do
      get :following
      get :followers
    end
  end

  get "terms",   to: "static#terms"
  get "privacy", to: "static#privacy"

  root "home#index"
  get "up" => "rails/health#show", as: :rails_health_check
end
