class Person < ActiveRecord::Base
  attr_accessible :approved, :biography, :birthday, :day_of_death, :homepage, :imdb_id, :locked, :name, :place_of_birth, :user_id, :original_id, :temp_user_id, :popular, :meta_title, :meta_description, :meta_keywords

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
  has_many :pending_items, :as => :pendable, :dependent => :destroy

  belongs_to :user

  validates_presence_of :name
  # validates :name, :uniqueness => { :case_sensitive => false }

  after_create :check_original_id

  serialize :locked, ActiveRecord::Coders::Hstore

  include PgSearch
  pg_search_scope :person_search, :against => [:name, :biography],
    using: {tsearch: {dictionary: "english", prefix: true}}

  def self.search(term)
    people = Person.where(approved: true).person_search(term)
    people = people.uniq
  end

  def self.find_popular
    self.select("id, name, popular").where("approved = TRUE AND popular != 0 AND popular IS NOT NULL").includes(:images).order("popular ASC")
  end

  def self.find_all_and_include(page)
    # self.find(:all, :includes => [:alternative_names, :casts, :crews, :images, :videos, :views, :follows, :person_social_apps, :tags])
    self.find(:all, :includes => [:images]).page(page).per(40)
  end

  def self.find_all_approved_includes(page)
    # self.where(approved: true).order("people.approved DESC, people.updated_at DESC").includes(:alternative_names, :casts, :crews, :images, :videos, :views, :follows, :person_social_apps, :tags)
    self.where(approved: true).order("people.approved DESC, people.updated_at DESC").includes(:images).page(page).per(40)
  end

  def self.all_by_user_or_temp(user_id, temp_id, page)
    self.where("user_id = ? OR temp_user_id = ?", user_id, temp_id).page(page).per(40)
  end

  def self.all_by_temp(temp_id, page)
    self.where("temp_user_id = ?", temp_id).page(page).per(40)
  end

  def self.order_include_my_people(page)
    self.order("people.approved DESC, people.updated_at DESC").includes(:images, :pending_items).page(page).per(40)
  end

  def self.find_and_include_by_id(id)
    self.where(id: id).includes(:alternative_names, :casts, :crews, :images, :videos, :views, :follows, :person_social_apps, :tags)
  end

  def self.find_and_include_all_approved
    self.where(approved: true).includes(:alternative_names, :casts, :crews, :images, :videos, :views, :follows, :person_social_apps, :tags)
  end

  def self.my_person_by_user(user_id)
    self.where("(approved = TRUE) OR (approved = FALSE AND user_id = ?)", user_id)
  end

  def self.my_person_by_temp(temp_id)
    self.where("(approved = TRUE) OR (approved = FALSE AND temp_user_id = ?)", temp_id)
  end

  private

  def check_original_id
    unless self.original_id
      self.original_id = self.id
      self.save
    end
  end

end
