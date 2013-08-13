class Crew < ActiveRecord::Base
  attr_accessible :approved, :job, :movie_id, :person_id, :user_id
  belongs_to :movie
  belongs_to :people
end
