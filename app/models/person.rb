class Person < ActiveRecord::Base
  attr_accessible :approved, :biography, :birthday, :day_of_death, :homepage, :imdb_id, :locked, :name, :place_of_birth, :user_id, :original_id, :temp_user_id

  has_many :alternative_names, :dependent => :destroy
  has_many :crews, :dependent => :destroy
  has_many :casts, :dependent => :destroy
  has_many :person_social_apps, :dependent => :destroy

  has_many :tags, :dependent => :destroy
  has_many :list_items, :as => :listable, :dependent => :destroy
  has_many :images, :as => :imageable, :dependent => :destroy
  has_many :videos, :as => :videable, :dependent => :destroy
  has_many :follows, :as => :followable, :dependent => :destroy
  has_many :views, :as => :viewable, :dependent => :destroy
  has_many :reports, :as => :reportable, :dependent => :destroy

  belongs_to :user

  validates_presence_of :name
  validates :name, :uniqueness => { :case_sensitive => false }

  after_create :check_original_id

  serialize :locked, ActiveRecord::Coders::Hstore

  include PgSearch
  pg_search_scope :person_search, :against => [:name, :biography],
    using: {tsearch: {dictionary: "english", prefix: true}}

  def self.search(term)
    people = Person.where(approved: true).person_search(term)
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
