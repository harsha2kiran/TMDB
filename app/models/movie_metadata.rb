class MovieMetadata < ActiveRecord::Base
  attr_accessible :approved, :budget, :homepage, :imdb_id, :movie_id, :movie_type_id, :runtime, :status_id, :user_id, :temp_user_id
  belongs_to :movie
  belongs_to :status
  belongs_to :user

  validates_presence_of :status_id
  validates :homepage, url: true, :allow_blank => true

end
