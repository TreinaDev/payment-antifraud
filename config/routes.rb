Rails.application.routes.draw do
  devise_for :users
  devise_for :admins
  root 'home#index'

  resources :promos, only: [:index, :new, :create, :show, :edit, :update] do
    resources :promo_products, only: %i[create destroy]
  end

  resources :payment_methods, only: [:index, :new, :create, :show, :edit, :update]
  resources :company_payment_options, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :users, only: %i[index] do
    resources :user_reviews, only: %i[new create]
  end

  resources :invoices, only: %i[index show edit update]
  resources :fraud_reports, only: %i[index show new create] do
    post 'approves', on: :member
    post 'denies', on: :member
  end
  resources :invoices, only: %i[index show] do
    resource :invoices_status_management, only: %i[update], controller:'invoices/invoices_status_management'
  end

  namespace :api do
    namespace :v1 do
      resources :invoices, only: [:show, :index, :create]
      resources :promos, only: [:show], param: :voucher
      resources :blocked_registration_numbers, only: [:show]
      resources :insurance_companies, only: %i[] do
        get 'payment_options', on: :member
      end
    end
  end
end
