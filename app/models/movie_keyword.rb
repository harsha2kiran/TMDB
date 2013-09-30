class MovieKeyword < ActiveRecord::Base
  attr_accessible :approved, :keyword_id, :movie_id, :user_id, :temp_user_id
  belongs_to :movie
  belongs_to :keyword
  belongs_to :user
  has_many :pending_items, :as => :approvable, :dependent => :destroy

  validates_presence_of :keyword_id, :movie_id
  validates_uniqueness_of :keyword_id, :scope => :movie_id

end
