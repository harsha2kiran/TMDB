class Language < ActiveRecord::Base
  attr_accessible :language, :approved
  has_many :alternative_titles, :dependent => :destroy
  has_many :movie_languages, :dependent => :destroy
end
