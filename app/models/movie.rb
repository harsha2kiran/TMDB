class Movie < ActiveRecord::Base
  attr_accessible :approved, :content_score, :locked, :overview, :tagline, :title, :user_id, :original_id, :popular
  has_many :alternative_titles
  has_many :crews
  has_many :casts
  has_many :movie_genres, :dependent => :destroy
  has_many :movie_keywords, :dependent => :destroy
  has_many :movie_languages, :dependent => :destroy
  has_many :movie_metadatas, :dependent => :destroy
  has_many :revenue_countries, :dependent => :destroy
  has_many :releases, :dependent => :destroy
  has_many :production_companies, :dependent => :destroy

  has_many :tags, :as => :taggable, :dependent => :destroy
  has_many :list_items, :as => :listable, :dependent => :destroy
  has_many :images, :as => :imageable, :dependent => :destroy
  has_many :videos, :as => :videable, :dependent => :destroy
  has_many :follows, :as => :followable, :dependent => :destroy
  has_many :views, :as => :viewable, :dependent => :destroy
  has_many :reports, :as => :reportable, :dependent => :destroy

  belongs_to :user

  validates_presence_of :title, :user_id
  validates :title, :uniqueness => { :case_sensitive => false }

  after_create :check_original_id

  serialize :locked, ActiveRecord::Coders::Hstore

  include PgSearch
  pg_search_scope :movie_search, :against => [:title, :tagline, :overview],
    using: {tsearch: {dictionary: "english", prefix: true}}

  def self.search(term)
    movies = Movie.where(approved: true).movie_search(term)
    movies = movies.uniq
  end

  private

  def check_original_id
    unless self.original_id
      self.original_id = self.id
      self.save
    end
  end

end
