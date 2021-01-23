Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get 'about', to: 'pages#about'

  resources :farms, only: [ :show ] do
    resources :calendrier, controller: 'events', only: [ :index, :edit, :update, :new, :create ]
    resources :produits, controller: 'products', only: [ :index, :show, :edit, :update ]
    resources :plandeculture, controller: 'crop_plan_lines', only: [ :index, :update ]
    resources :ventes, controller: 'sales', only: [ :index, :show ]
    resources :pointsdevente, controller: 'outlets', only: [ :index, :show ]
    resources :thebest, controller: 'users', only: [ :show ]
    resources :user_events, only: [ :create, :update ]
    get 'dashboard', to: 'pages#dashboard'
  end
end
