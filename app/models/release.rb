class Release < ActiveRecord::Base
  attr_accessible :approved, :certification, :confirmed, :country_id, :movie_id, :primary, :release_date, :user_id
  belongs_to :country
  belongs_to :movie
  belongs_to :user

  validates_presence_of :country_id, :release_date, :movie_id, :user_id

end
