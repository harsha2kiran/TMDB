class Language < ActiveRecord::Base
  attr_accessible :language, :approved
  has_many :alternative_titles
  has_many :movie_languages
end
