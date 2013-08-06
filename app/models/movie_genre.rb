class MovieGenre < ActiveRecord::Base
  attr_accessible :approved, :genre_id, :movie_id
end
