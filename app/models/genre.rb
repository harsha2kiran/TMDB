class Genre < ActiveRecord::Base
  attr_accessible :genre, :approved
  attr_accessor :movies
  has_many :movie_genres
  has_many :follows, :as => :followable
end
