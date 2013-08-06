class Keyword < ActiveRecord::Base
  attr_accessible :keyword
  has_many :movie_keywords
end
