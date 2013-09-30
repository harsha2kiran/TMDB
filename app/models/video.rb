class Video < ActiveRecord::Base
  attr_accessible :approved, :link, :link_active, :priority, :quality, :videable_id, :videable_type, :video_type, :user_id, :title, :description, :category, :comments, :duration, :thumbnail, :temp_user_id
  belongs_to :videable, polymorphic: true

  has_many :tags, :as => :taggable, :dependent => :destroy
  has_many :list_items, :as => :listable, :dependent => :destroy
  has_many :images, :as => :imageable, :dependent => :destroy
  has_many :follows, :as => :followable, :dependent => :destroy
  has_many :views, :as => :viewable, :dependent => :destroy
  has_many :reports, :as => :reportable, :dependent => :destroy
  has_many :views, :as => :viewable, :dependent => :destroy
  has_many :pending_items, :as => :approvable, :dependent => :destroy

  belongs_to :user

  validates_presence_of :link, :priority, :quality, :title
  validates :link, url: true
  validates :link, :uniqueness => { :scope => [:videable_id, :videable_type] }

  include PgSearch
  pg_search_scope :video_search, :against => [:title],
    using: {tsearch: {dictionary: "english", prefix: true}}

  def self.search(term)
    videos = Video.where(approved: true).video_search(term)
    videos = videos.uniq
  end

end
