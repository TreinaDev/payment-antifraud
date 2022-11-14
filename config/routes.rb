Rails.application.routes.draw do
  devise_for :users
  devise_for :admins 
  root 'home#index'

  resources :promos, only: [:index, :new, :create, :show, :edit, :update]
  resources :payment_methods, only: [:index, :new, :create, :show, :edit, :update]
  resources :company_payment_options, only: [:index, :show, :new, :create, :edit, :update]
  resources :users, only: %i[index] do 
    resources :user_reviews, only: %i[new create]
  end

  resources :invoices, only: %i[index show] do 
    resource :invoices_status_management, only: %i[update], controller:'invoices/invoices_status_management'  
  end
  namespace :api do 
    namespace :v1 do 
      resources :invoices, only: [:show, :index, :create]
    end
  end
end
