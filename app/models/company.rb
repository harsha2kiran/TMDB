class Company < ActiveRecord::Base
  attr_accessible :approved, :company
  has_many :production_companies, :dependent => :destroy
end
