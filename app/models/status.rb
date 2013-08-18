class Status < ActiveRecord::Base
  attr_accessible :status
  has_many :movie_metadatas

  validates_presence_of :status

end
