class Video < ActiveRecord::Base
  attr_accessible :approved, :link, :link_active, :priority, :quality, :videable_id, :videable_type, :video_type
  belongs_to :videable, polymorphic: true
  has_many :list_content, :as => :listable
  has_many :follows, :as => :followable
  has_many :views, :as => :viewable
  has_many :reports, :as => :reportable
end
