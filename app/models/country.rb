class Country < ActiveRecord::Base
  attr_accessible :iso, :country
  has_many :revenue_countries, :dependent => :destroy
end
