Rails.application.routes.draw do
  devise_for :users
  devise_for :admins
  root 'home#index'
  

  resources :users, only: %i[index] do 
    resources :user_approvals, only: %i[new create]
  end
end
