class MovieGenre < ActiveRecord::Base
  attr_accessible :approved, :genre_id, :movie_id, :user_id
  belongs_to :movie
  belongs_to :genre
end
