class Movie < ActiveRecord::Base
  attr_accessible :approved, :content_score, :locked, :overview, :tagline, :title
end
