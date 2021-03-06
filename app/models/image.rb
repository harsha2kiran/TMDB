class Image < ActiveRecord::Base
  attr_accessible :approved, :image_file, :image_type, :is_main_image, :imageable_id, :imageable_type, :title, :user_id, :priority, :temp_user_id, :description
  # attr_accessor :small_height

  belongs_to :imageable, polymorphic: true
  belongs_to :user

  has_many :media_keywords, :as => :mediable, :dependent => :destroy
  has_many :media_tags, :as => :mediable, :dependent => :destroy
  # has_many :tags, :as => :taggable, :dependent => :destroy
  has_many :list_items, :as => :listable, :dependent => :destroy
  has_many :videos, :as => :videable, :dependent => :destroy
  has_many :follows, :as => :followable, :dependent => :destroy
  has_many :views, :as => :viewable, :dependent => :destroy
  has_many :reports, :as => :reportable, :dependent => :destroy
  has_many :pending_items, :as => :approvable, :dependent => :destroy
  has_many :likes, :as => :likable, :dependent => :destroy

  mount_uploader :image_file, ImageUploader

  include PgSearch
  pg_search_scope :image_search, :against => [:title],
    using: {tsearch: {dictionary: "english", prefix: true}}

  def self.search(term)
    images = Image.where(approved: true).image_search(term)
    images = images.uniq
  end

end
