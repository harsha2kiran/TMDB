class RevenueCountry < ActiveRecord::Base
  attr_accessible :approved, :country_id, :movie_id, :revenue, :user_id, :temp_user_id
  belongs_to :country
  belongs_to :movie
  belongs_to :user
  has_many :pending_items, :as => :approvable, :dependent => :destroy

  validates_presence_of :country_id, :revenue, :movie_id
  validates_uniqueness_of :country_id, :scope => :movie_id

end
