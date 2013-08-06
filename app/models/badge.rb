class Badge < ActiveRecord::Base
  attr_accessible :badge, :min_points
  has_and_belongs_to_many :users
end
