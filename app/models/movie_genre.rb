class MovieGenre < ActiveRecord::Base
  attr_accessible :approved, :genre_id, :movie_id, :user_id, :temp_user_id
  belongs_to :movie
  belongs_to :genre
  belongs_to :user
  has_many :pending_items, :as => :approvable, :dependent => :destroy

  validates_presence_of :genre_id, :movie_id
  validates_uniqueness_of :genre_id, :scope => :movie_id

end
