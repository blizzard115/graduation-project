Rails.application.routes.draw do
  devise_for :users

  resources :posts do
    resource :like, only: [:create, :destroy]
  end

  resources :users, only: [:show]

  root "home#index"
  get "up" => "rails/health#show", as: :rails_health_check
end
