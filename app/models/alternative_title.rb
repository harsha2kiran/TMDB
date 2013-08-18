class AlternativeTitle < ActiveRecord::Base
  attr_accessible :alternative_title, :approved, :language_id, :movie_id, :user_id

  belongs_to :movie
  belongs_to :language
  belongs_to :user

  validates_presence_of :alternative_title, :language_id, :movie_id, :user_id

end
