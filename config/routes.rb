Movies::Application.routes.draw do

  ActiveAdmin.routes(self)

  # devise_for :admin_users, ActiveAdmin::Devise.config

  devise_for :users

  use_doorkeeper

  api_version(:module => "Api::V1", :path => {value:"api/v1"}, :defaults => {:format => :json}) do
    resources :alternative_names
    resources :alternative_titles
    resources :badges
    resources :media_keywords
    resources :media_tags
    resources :list_keywords
    resources :list_tags
    resources :likes
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
    resources :images do
      get "related_images" => "images#related_images"
    end
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
        get "my_lists" => "lists#my_lists"
        get "my_galleries" => "lists#my_galleries"
        get "my_channels" => "lists#my_channels"
      end
    end
    resources :movie_genres
    resources :movie_keywords
    resources :movie_languages
    resources :movie_metadatas
    resources :movies do
      collection do
        post 'expire' => 'movies#expire'
        get "get_popular" => "movies#get_popular"
        get "edit_popular" => "movies#edit_popular"
        get "search" => "movies#search"
        get "my_movies" => "movies#my_movies"
      end
      get "my_movie" => "movies#my_movie"
    end
    resources :people do
      collection do
        get "get_popular" => "people#get_popular"
        get "edit_popular" => "people#edit_popular"
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
    resources :tags do
      collection do
        get "search" => "tags#search"
      end
    end
    # resources :user_badges

    resources :videos do
      collection do
        get "validate_links" => "videos#validate_links"
        post "check" => "videos#check"
        post "fetch_username" => "videos#fetch_username"
        post "fetch_search" => "videos#fetch_search"
        post "fetch_playlist" => "videos#fetch_playlist"
        post "import_all" => "videos#import_all"
      end
    end

    resources :views, only: [:create]

    resources :users, :only => [:show, :update] do
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
        post "inline_edit" => "approvals#inline_edit"
        post "add_remove_pending" => "approvals#add_remove_pending"
        post "add_remove_main_pending" => "approvals#add_remove_main_pending"
      end
    end
    get '/search' => 'search#search', :as => :search
    post 'cache/expire' => 'cache#expire'
    resources :locks, only: [:show] do
      collection do
        post "mark" => "locks#mark"
        post "unmark" => "locks#unmark"
      end
    end
  end
  root :to => 'application#index'
  resources :movies, only: [:show, :index]
  resources :people, only: [:show, :index]
  resources :genres, only: [:show, :index]
  resources :lists do
    collection do
      get "galleries" => "lists#galleries"
      get "channels" => "lists#channels"
    end
  end
  resources :images, only: [:show]
  resources :videos, only: [:show]
end
