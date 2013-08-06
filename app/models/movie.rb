class Movie < ActiveRecord::Base
  attr_accessible :approved, :content_score, :locked, :overview, :tagline, :title
  has_many :alternative_titles
  has_many :crews
  has_many :cast
  has_many :movie_genres
  has_many :movie_keywords
  has_many :movie_languages
  has_many :movie_metadatas
  has_many :revenue_countries

  has_many :tags, :as => :taggable
  has_many :list_items, :as => :listable
  has_many :images, :as => :imageable
  has_many :videos, :as => :videable
  has_many :follows, :as => :followable
  has_many :views, :as => :viewable
  has_many :reports, :as => :reportable

end
