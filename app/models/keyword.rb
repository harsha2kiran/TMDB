class Keyword < ActiveRecord::Base
  attr_accessible :keyword, :approved
  has_many :movie_keywords, :dependent => :destroy

  validates_presence_of :keyword
  validates :keyword, :uniqueness => { :case_sensitive => false }

end
