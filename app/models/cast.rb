class Cast < ActiveRecord::Base
  attr_accessible :approved, :character, :movie_id, :person_id
  belongs_to :movie
  belongs_to :people
end
