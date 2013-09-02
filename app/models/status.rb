class Status < ActiveRecord::Base
  attr_accessible :status
  has_many :movie_metadatas, :dependent => :destroy

  validates_presence_of :status

end
