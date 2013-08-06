class MovieLanguage < ActiveRecord::Base
  attr_accessible :approved, :language_id, :movie_id
  belongs_to :language
  belongs_to :movie
end
