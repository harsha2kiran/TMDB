class MovieMetadata < ActiveRecord::Base
  attr_accessible :approved, :budget, :homepage, :imdb_id, :movie_id, :movie_type_id, :runtime, :status_id
  belongs_to :movie
  belongs_to :status
end
