class AlternativeTitle < ActiveRecord::Base
  attr_accessible :alternative_title, :approved, :language_id, :movie_id
  belongs_to :movie
  belongs_to :language
end
