class Status < ActiveRecord::Base
  attr_accessible :status
  has_many :movie_metadatas
end
