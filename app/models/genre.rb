class Genre < ActiveRecord::Base
  attr_accessible :genre
  has_many :movie_genres
end
