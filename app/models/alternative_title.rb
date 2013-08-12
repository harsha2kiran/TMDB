class AlternativeTitle < ActiveRecord::Base
  attr_accessible :alternative_title, :approved, :language_id, :movie_id

  belongs_to :movie
  belongs_to :language

  def language
    self.language
  end

  def language=(id)
    Language.find self.language_id
  end

end
