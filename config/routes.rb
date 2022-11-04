Rails.application.routes.draw do
  devise_for :users
  devise_for :admins
  root 'home#index'
  
  resources :home, only: %i[index] do 
    get 'registered_users', on: :collection
  end
end
