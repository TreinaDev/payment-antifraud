Rails.application.routes.draw do
  devise_for :users
  devise_for :admins

  root to: "home#index"
  resources :promos, only: [:index, :new, :create]
end
