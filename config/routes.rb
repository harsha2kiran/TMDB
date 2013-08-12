Movies::Application.routes.draw do

  ActiveAdmin.routes(self)

  # devise_for :admin_users, ActiveAdmin::Devise.config

  devise_for :users

  mount Doorkeeper::Engine => '/oauth'

  api_version(:module => "Api::V1", :path => "api/v1", :defaults => {:format => :json}) do
    resources :alternative_names
    resources :alternative_titles
    resources :badges
    resources :casts
    resources :crews
    resources :companies
    resources :countries
    resources :follows do
      collection do
        get "filter" => "follows#filter"
      end
    end
    resources :genres
    resources :images
    resources :keywords
    resources :languages
    resources :list_items
    resources :lists
    resources :movie_genres
    resources :movie_keywords
    resources :movie_languages
    resources :movie_metadatas
    resources :movies
    resources :people
    resources :person_social_apps
    resources :production_companies
    resources :releases
    resources :reports
    resources :revenue_countries
    resources :social_apps
    resources :statuses
    resources :tags
    # resources :user_badges
    resources :videos
    # resources :views
    resources :users, :only => [:show] do
      put "toggle_active" => "users#toggle_active"
    end
    resources :approvals do
      collection do
        post "mark" => "approvals#mark"
      end
    end
  end

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
  root :to => 'application#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
