class MovieLanguage < ActiveRecord::Base
  attr_accessible :approved, :language_id, :movie_id
end
