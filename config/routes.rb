Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :users
  devise_for :admins
  resources :payment_methods, only: [:new, :create, :show] 
end
