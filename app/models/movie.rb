class Movie < ActiveRecord::Base
  attr_accessible :approved, :content_score, :locked, :overview, :tagline, :title, :user_id, :original_id, :popular, :temp_user_id
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

  validates_presence_of :title
  # validates :title, :uniqueness => { :case_sensitive => false }

  after_create :check_original_id

  serialize :locked, ActiveRecord::Coders::Hstore

  include PgSearch
  pg_search_scope :movie_search, :against => [:title, :tagline, :overview],
    using: {tsearch: {dictionary: "english", prefix: true}}

  def self.search(term)
    movies = Movie.where(approved: true).movie_search(term)
    movies = movies.uniq
  end

  def self.find_all_includes
    self.find(:all, :includes => [:alternative_titles, :casts, :crews, :movie_genres, :movie_keywords, :revenue_countries, :production_companies, :releases])
  end

  def self.find_all_approved_includes
    self.where(approved: true).order("movies.approved DESC, movies.updated_at DESC").includes(:alternative_titles, :casts, :crews, :movie_genres, :movie_keywords, :revenue_countries, :production_companies, :releases, :images, :videos, :views, :follows, :tags, :movie_languages, :movie_metadatas)
  end

  def self.all_by_user_or_temp(user_id, temp_id)
    self.where("user_id = ? OR temp_user_id = ?", user_id, temp_id)
  end

  def self.all_by_temp(temp_id)
    self.where("temp_user_id = ?", temp_id)
  end

  def self.order_include_my_movies
    self.order("movies.approved DESC, movies.updated_at DESC").includes(:alternative_titles, :casts, :crews, :movie_genres, :movie_keywords, :revenue_countries, :production_companies, :releases, :images, :videos, :views, :follows, :tags, :movie_languages, :movie_metadatas)
  end

  def self.find_and_include_by_id(id)
    self.where(id: id).includes(:alternative_titles, :casts, :crews, :movie_genres, :movie_keywords, :revenue_countries, :production_companies, :releases, :images, :videos, :views, :follows, :tags, :movie_languages, :movie_metadatas)
  end

  def self.find_and_include_all_approved
    self.where(approved: true).includes(:alternative_titles, :casts, :crews, :movie_genres, :movie_keywords, :revenue_countries, :production_companies, :releases, :images, :videos, :views, :follows, :tags, :movie_languages, :movie_metadatas)
  end

  def self.my_movie_by_user(user_id)
    self.where("(approved = TRUE) OR (approved = FALSE AND user_id = ?)", user_id)
  end

  def self.my_movie_by_temp(temp_id)
    self.where("(approved = TRUE) OR (approved = FALSE AND temp_user_id = ?)", temp_id)
  end

  def self.find_popular
    self.select("id, title, popular").where("approved = TRUE AND popular != 0 AND popular IS NOT NULL").includes(:images).order("popular ASC")
  end

  private

  def check_original_id
    unless self.original_id
      self.original_id = self.id
      self.save
    end
  end

end
