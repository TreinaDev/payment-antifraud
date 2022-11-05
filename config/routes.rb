Rails.application.routes.draw do
  devise_for :users
  devise_for :admins
  resources :payment_methods, only: [:index, :new, :create, :show] 
  root 'home#index'
end
