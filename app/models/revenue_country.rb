class RevenueCountry < ActiveRecord::Base
  attr_accessible :approved, :country_id, :movie_id, :revenue, :user_id
  belongs_to :country
  belongs_to :movie
  belongs_to :user
end
