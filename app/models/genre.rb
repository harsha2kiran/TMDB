class Genre < ActiveRecord::Base
  attr_accessible :genre, :approved
  attr_accessor :movies
  has_many :movie_genres, :dependent => :destroy
  has_many :follows, :as => :followable, :dependent => :destroy
end
