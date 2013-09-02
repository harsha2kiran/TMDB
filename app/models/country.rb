class Country < ActiveRecord::Base
  attr_accessible :country
  has_many :revenue_countries, :dependent => :destroy
end
