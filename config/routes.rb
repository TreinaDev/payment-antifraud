Rails.application.routes.draw do
  resources :promo_products
  devise_for :users
  devise_for :admins 
  root 'home#index'

  resources :promos, only: [:index, :new, :create, :show, :edit, :update] do 
    resources :promo_products, only: %i[create destroy]
  end

  namespace :api do
    namespace :v1 do
      resources :promos, only: [:show, :index]
    end
  end

  resources :payment_methods, only: [:index, :new, :create, :show, :edit, :update]
  resources :company_payment_options, only: [:index, :show, :new, :create, :edit, :update]
  resources :users, only: %i[index] do 
    resources :user_reviews, only: %i[new create]
  end

  namespace :api do 
    namespace :v1 do 
      resources :insurance_companies, only: %i[] do 
        get 'payment_options', on: :member
      end
    end
  end
end
