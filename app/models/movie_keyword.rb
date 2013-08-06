class MovieKeyword < ActiveRecord::Base
  attr_accessible :approved, :keyword_id, :movie_id
  belongs_to :movie
  belongs_to :keyword
end
