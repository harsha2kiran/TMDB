class RevenueCountry < ActiveRecord::Base
  attr_accessible :approved, :country_id, :movie_id, :revenue
  belongs_to :country
  belongs_to :movie
end
