class Language < ActiveRecord::Base
  attr_accessible :language, :approved
  has_many :alternative_titles, :dependent => :destroy
  has_many :movie_languages, :dependent => :destroy

  validates_presence_of :language
  validates :language, :uniqueness => { :case_sensitive => false }

end
