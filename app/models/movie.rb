class Movie < ActiveRecord::Base
  attr_accessible :approved, :content_score, :overview, :tagline, :title
end
