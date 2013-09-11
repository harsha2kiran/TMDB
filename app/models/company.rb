class Company < ActiveRecord::Base
  attr_accessible :approved, :company
  has_many :production_companies, :dependent => :destroy

  validates_presence_of :company
  validates :company, :uniqueness => { :case_sensitive => false }

end
