Rails.application.routes.draw do
  devise_for :users

  resources :posts do
    resource :like, only: [:create, :destroy]
  end

  resources :users, only: [:show] do
    member do
      get :likes   # /users/:id/likes
    end
  end

  resources :tags, only: [:show], param: :name

  root "home#index"
  get "up" => "rails/health#show", as: :rails_health_check
end
