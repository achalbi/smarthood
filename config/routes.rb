EMS::Application.routes.draw do


  get "issue_ticket_action/destroy"

  get "issue_ticket_action/update"

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
  resources :user_groups
  #resources :posts
  resources :comments
  #resources :events
  resources :activities
  resources :authentication

  resources :activitynotificationsetting
  resources :ticket_action
  resources :buysell do
    collection do
      post :add_category, :add_subcategory, :search_items
      get :load_subcategory
    end
  end
  
  resources :issue_ticket_action, :only => [:create, :destroy]

  resources :issue_trackers do
    collection do
      put :update_action
      post :quick_filter
    end
  end

  resources :activitynotifications do
    member do
      get :mark_read
    end
    collection do
      get :update_count
    end
  end

  resources :albums do
    collection do
      get :edit,:list,:updates,:delete_photos
    end
  end

  resources :photos do
    collection do
      get :updates,:delete_photos
    end
  end
  
  resources :activities do
    collection do
      post :create_album
    end
  end

  resources :password_resets do
    member do
      get :add
    end
  end

  resources :communities do
    member do
      get :setactive, :sendrequest, :join_cu, :acceptrequest, :declinerequest, :search_app_user, :invite_app_user, :invite_fb_friends, :invite_by_email, :unjoin_cu, :add_moderators
    end
    collection do
      get :active_com , :joined_com, :public_com, :private_com, :moderated_com, :search_address, :get_geo_coordinates
    end
  end 
   
  resources :shares
  #match '/delete_photos', to: 'albums#delete_photos'

 # match '/auth/:provider/callback', to: 'sessions#create' #omniauth route




  resources :posts do
    collection do
      get :cus_post_paginate
    end
     resources :photos, :only => [:create, :destroy]
    resources :comments
  end
  resources :post, :has_many => [:user_groups]

  resources :users do
    member do
      get :following, :followers
    end
  end

    resources :users do
      collection do
        get :search_auto
        post :search_users
      end
    end

  resources :events do
    collection  do
      get :inviteuser, :eventeditors, :search_address, :get_geo_coordinates, :upcoming_events_paginate, :today_events_paginate, :past_events_paginate, :search_user_group, :search_auto_user, :search_auto_group, :post_paginate 
    end
    member do
      get :search_selected_user, :search_selected_group
    end
    resources :activities  
  end

  resources :groups do
    member do
      get :followers, :add_moderators, :invite_app_user, :search_app_user
    end
    collection do
      get :my, :public, :post_paginate, :group_post, :groups_post_paginate, :search_app_user
      post :create_album
    end
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
  match '/signout', to: 'sessions#destroy' #, via: :delete
  

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
