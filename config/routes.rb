Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get 'about', to: 'pages#about'

  resources :farms, only: [ :show ] do
    resources :calendrier, controller: 'events', only: [ :index, :edit, :update, :new, :create, :destroy ]
    post "events_multiple_update", to: 'events#events_multiple_update'

    resources :produits, controller: 'products', only: [ :index, :show, :edit, :update, :create, :new ]
    resources :variets, controller: 'vegetable_variets', only: [ :edit, :update, :create, :new ]
    get "product_variets_multiple_new", to: 'products#product_variets_multiple_new'
    post "product_variets_multiple_create", to: 'products#product_variets_multiple_create'
    resources :plandeculture, controller: 'crop_plan_lines', only: [ :index, :update, :edit ]
    resources :crop_plan_line_events, only: [ :update ]
    resources :newsletter_subscribers, only: [ :index, :new, :create ]
    resources :crop_plan_line_user_events, only: [ :create, :update, :destroy ]
    resources :ventes, controller: 'sales', only: [ :index, :show ]
    resources :poulettes, controller: 'hen_actions', only: [ :index, :show, :new, :create, :destroy, :edit, :update ]
    resources :decisions, only: [ :index, :show, :new, :create, :destroy, :edit, :update ]
    resources :pointsdevente, controller: 'outlets', only: [ :index, :show, :new, :create ] do
      resources :baskets, only: [ :new, :create ]
      resources :factures, controller: "invoices", only: [ :new, :create, :index, :show, :update, :destroy ]
      resources :sales, only: [ :index, :show, :new, :create, :update, :destroy ] do
        resources :livraisons, controller: "delivery_slips", only: [ :new, :create, :index, :show, :update, :destroy ]
        resources :baskets, only: [ :index, :show, :update, :destroy ] do
          resources :basket_lines, only: [ :index, :show, :new, :update, :create, :destroy ]
        end
      end
    end
    resources :thebest, controller: 'users', only: [ :show ]
    resources :sales_lines, only: [ :index, :show, :new, :update, :create, :destroy ]
    get "last_prices_multiple_new", to: 'outlets#last_prices_multiple_new'
    post "last_prices_multiple_create", to: 'outlets#last_prices_multiple_create'
    resources :user_events, only: [ :create, :update, :destroy ]
    get 'dashboard', to: 'pages#dashboard'
  end
end
