Rails.application.routes.draw do
  devise_for :users
  devise_for :admins
  resources :payment_methods, only: [:index, :new, :create, :show, :edit, :update] 
  root 'home#index'
  

  resources :users, only: %i[index] do 
    resources :user_approvals, only: %i[new create]
  end
end
