Rails.application.routes.draw do
  devise_for :users

  resources :posts
  resources :users, only: [:show]

  root "home#index"
  get "up" => "rails/health#show", as: :rails_health_check
end
