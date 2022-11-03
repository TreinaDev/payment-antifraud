Rails.application.routes.draw do
  devise_for :users
  devise_for :admins
<<<<<<< HEAD
  root 'home#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
=======
>>>>>>> Configura o I18n no model promo

  root to: "home#index"
  resources :promos, only: [:index, :new, :create, :show]
end
