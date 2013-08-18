class RevenueCountry < ActiveRecord::Base
  attr_accessible :approved, :country_id, :movie_id, :revenue, :user_id
  belongs_to :country
  belongs_to :movie
  belongs_to :user

  validates_presence_of :country_id, :revenue, :movie_id, :user_id

end
