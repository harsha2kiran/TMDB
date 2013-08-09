class Person < ActiveRecord::Base
  attr_accessible :approved, :biography, :birthday, :day_of_death, :homepage, :imdb_id, :locked, :name, :place_of_birth

  has_many :alternative_names
  has_many :crews
  has_many :casts
  has_many :person_social_apps

  has_many :tags
  has_many :list_items, :as => :listable
  has_many :images, :as => :imageable
  has_many :videos, :as => :videable
  has_many :follows, :as => :followable
  has_many :views, :as => :viewable
  has_many :reports, :as => :reportable
end
