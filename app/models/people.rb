class People < ActiveRecord::Base
  attr_accessible :approved, :biography, :birthday, :day_of_death, :homepage, :imdb_id, :locked, :name, :place_of_birth
  has_many :alternative_names
  has_many :crews
  has_many :tagged_people, :as => :taggable
  has_many :list_content, :as => :listable
  has_many :follows, :as => :followable
  has_many :views, :as => :viewable
  has_many :reports, :as => :reportable
end
