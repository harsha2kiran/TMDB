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
    resources :companies do
      collection do
        get "search" => "companies#search"
      end
    end

    resources :countries do
      collection do
        get "search" => "countries#search"
      end
    end
    resources :follows do
      collection do
        get "filter" => "follows#filter"
      end
    end
    resources :genres do
      collection do
        get "search" => "genres#search"
      end
    end
    resources :images
    resources :keywords do
      collection do
        get "search" => "keywords#search"
      end
    end
    resources :languages do
      collection do
        get "search" => "languages#search"
      end
    end
    resources :list_items
    resources :lists do
      collection do
        get "search_my_lists" => "lists#search_my_lists"
        get "galleries" => "lists#galleries"
        get "channels" => "lists#channels"
      end
    end
    resources :movie_genres
    resources :movie_keywords
    resources :movie_languages
    resources :movie_metadatas
    resources :movies do
      collection do
        get "get_popular" => "movies#get_popular"
        get "edit_popular" => "movies#edit_popular"
        get "search" => "movies#search"
        get "my_movies" => "movies#my_movies"
      end
      get "my_movie" => "movies#my_movie"
    end
    resources :people do
      collection do
        get "search" => "people#search"
        get "my_people" => "people#my_people"
      end
      get "my_person" => "people#my_person"
    end
    resources :person_social_apps
    resources :production_companies
    resources :releases
    resources :reports
    resources :revenue_countries
    resources :social_apps do
      collection do
        get "search" => "social_apps#search"
      end
    end

    resources :statuses do
      collection do
        get "search" => "statuses#search"
      end
    end
    resources :tags
    # resources :user_badges

    resources :videos do
      collection do
        get "validate_links" => "videos#validate_links"
        post "check" => "videos#check"
      end
    end

    resources :views, only: [:create]

    resources :users, :only => [:show] do
      put "toggle_active" => "users#toggle_active"
      collection do
        get "get_current_user" => "users#get_current_user"
      end
    end
    resources :approvals do
      collection do
        post "mark" => "approvals#mark"
        get "main_items" => "approvals#main_items"
        get "main_item" => "approvals#main_item"
        get "items" => "approvals#items"
        get "item" => "approvals#item"
      end
    end
    get '/search' => 'search#search', :as => :search
    resources :locks, only: [:show] do
      collection do
        post "mark" => "locks#mark"
        post "unmark" => "locks#unmark"
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
