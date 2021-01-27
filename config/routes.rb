Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get 'about', to: 'pages#about'

  resources :farms, only: [ :show ] do
    resources :calendrier, controller: 'events', only: [ :index, :edit, :update, :new, :create, :destroy ]
    resources :produits, controller: 'products', only: [ :index, :show, :edit, :update, :create, :new ]
    resources :plandeculture, controller: 'crop_plan_lines', only: [ :index, :update ]
    resources :crop_plan_line_events, only: [ :update ]
    resources :crop_plan_line_user_events, only: [ :create, :update, :destroy ]
    resources :ventes, controller: 'sales', only: [ :index, :show ]
    resources :pointsdevente, controller: 'outlets', only: [ :index, :show ]
    resources :thebest, controller: 'users', only: [ :show ]
    resources :user_events, only: [ :create, :update, :destroy ]
    get 'dashboard', to: 'pages#dashboard'
  end
end
