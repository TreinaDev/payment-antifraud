Rails.application.routes.draw do
  devise_for :users
  devise_for :admins
  root 'home#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root to: "home#index"
  resources :promos, only: [:index, :new, :create, :show, :edit, :update]
end
