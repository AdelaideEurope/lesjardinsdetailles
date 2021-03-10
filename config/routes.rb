Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get 'about', to: 'pages#about'

  resources :farms, only: [ :show ] do
    resources :calendrier, controller: 'events', only: [ :index, :edit, :update, :new, :create, :destroy ]
    resources :produits, controller: 'products', only: [ :index, :show, :edit, :update, :create, :new ]
    resources :variets, controller: 'vegetable_variets', only: [ :edit, :update, :create, :new ]
    get "product_variets_multiple_new", to: 'products#product_variets_multiple_new'
    post "product_variets_multiple_create", to: 'products#product_variets_multiple_create'
    resources :plandeculture, controller: 'crop_plan_lines', only: [ :index, :update, :edit ]
    resources :crop_plan_line_events, only: [ :update ]
    resources :newsletter_subscribers, only: [ :index, :new, :create ]
    resources :crop_plan_line_user_events, only: [ :create, :update, :destroy ]
    resources :ventes, controller: 'sales', only: [ :index, :show ]
    resources :pointsdevente, controller: 'outlets', only: [ :index, :show, :new, :create ] do
      resources :sales, only: [ :index, :show, :new, :create, :update, :destroy ]
    end
    resources :thebest, controller: 'users', only: [ :show ]
    resources :sales_lines, only: [ :index, :show, :new, :create, :destroy ]
    resources :user_events, only: [ :create, :update, :destroy ]
    get 'dashboard', to: 'pages#dashboard'
  end
end
