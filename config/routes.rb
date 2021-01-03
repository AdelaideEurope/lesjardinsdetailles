Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get 'about', to: 'pages#about'

  resources :farms, only: [ :show ]
  resources :calendrier, controller: 'events', only: [ :index ]
  resources :produits, controller: 'products', only: [ :index ]
  resources :plandeculture, controller: 'crop_plan_lines', only: [ :index ]
end
