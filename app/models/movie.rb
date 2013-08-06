class Movie < ActiveRecord::Base
  attr_accessible :approved, :content_score, :locked, :overview, :tagline, :title
  has_many :alternative_titles
  has_many :crews
  has_many :images, :as => :imageable
  has_many :videos, :as => :videable
  has_many :list_content, :as => :listable
  has_many :follows, :as => :followable
  has_many :views, :as => :viewable
  has_many :reports, :as => :reportable
end
