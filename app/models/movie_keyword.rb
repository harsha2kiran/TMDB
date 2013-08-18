class MovieKeyword < ActiveRecord::Base
  attr_accessible :approved, :keyword_id, :movie_id, :user_id
  belongs_to :movie
  belongs_to :keyword
  belongs_to :user

  validates_presence_of :keyword_id, :movie_id, :user_id

end
