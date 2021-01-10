Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get 'about', to: 'pages#about'

  resources :farms, only: [ :show ] do
    resources :calendrier, controller: 'events', only: [ :index ]
    resources :produits, controller: 'products', only: [ :index, :show ]
    resources :plandeculture, controller: 'crop_plan_lines', only: [ :index ]
    get 'dashboard', to: 'pages#dashboard'
  end
end
