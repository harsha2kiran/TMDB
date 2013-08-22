class Video < ActiveRecord::Base
  attr_accessible :approved, :link, :link_active, :priority, :quality, :videable_id, :videable_type, :video_type, :user_id, :title
  belongs_to :videable, polymorphic: true

  has_many :tags, :as => :taggable
  has_many :list_items, :as => :listable
  has_many :images, :as => :imageable
  has_many :follows, :as => :followable
  has_many :views, :as => :viewable
  has_many :reports, :as => :reportable

  belongs_to :user

  validates_presence_of :link, :user_id, :priority, :quality, :videable_id, :videable_type, :video_type, :title
  validates :link, url: true

  include PgSearch
  pg_search_scope :video_search, :against => [:title],
    using: {tsearch: {dictionary: "english", prefix: true}}

  def self.search(term)
    videos = Video.where(approved: true).video_search(term)
    videos = videos.uniq
  end

end
