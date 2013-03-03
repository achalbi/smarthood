EMS::Application.routes.draw do



  #get "authentication/index"

  #get "authentication/create"

  #get "authentication/destroy"

 # get "activities/new"

  match '/auth/:provider/callback' => 'authentication#create'
  match '/auth/failure' => 'authentication#failure'

  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :password_resets
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :groups
  resources :user_groups
  resources :posts
  resources :comments
  resources :photos
  resources :events
  resources :activities
  resources :authentication
  resources :albums

 # match '/auth/:provider/callback', to: 'sessions#create' #omniauth route

  resources :post, :has_many => [:user_groups]

  resources :posts do
    resources :comments
  end

  resources :users do
    member do
      get :following, :followers
    end
  end

  resources :events do
    resources :activities
  end

  resources :events do
    collection  do
      get :inviteuser, :eventeditors
    end
  end

  resources :groups do
    member do
      get :followers
    end
  end

  resources :posts do
     resources :photos, :only => [:create, :destroy]
  end

  resources :users do
     resources :photos, :only => [:create, :destroy]
  end

  root to: 'static_pages#home'


  match '/help',    to: 'static_pages#help'
  match '/about',   to: 'static_pages#about'
  match '/contact', to: 'static_pages#contact'


  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete
  

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
