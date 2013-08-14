class Person < ActiveRecord::Base
  attr_accessible :approved, :biography, :birthday, :day_of_death, :homepage, :imdb_id, :locked, :name, :place_of_birth, :user_id, :original_id

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

  after_create :check_original_id

  serialize :locked, ActiveRecord::Coders::Hstore

  include PgSearch
  pg_search_scope :person_search, :against => [:name, :biography],
    using: {tsearch: {dictionary: "english", prefix: true}}

  def self.search(term)
    people = Person.person_search(term)
    people = people.uniq
  end

  private

  def check_original_id
    unless self.original_id
      self.original_id = self.id
      self.save
    end
  end

end
