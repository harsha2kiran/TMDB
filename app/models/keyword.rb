class Keyword < ActiveRecord::Base
  attr_accessible :keyword, :approved
  has_many :movie_keywords
end
