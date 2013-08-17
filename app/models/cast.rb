class Cast < ActiveRecord::Base
  attr_accessible :approved, :character, :movie_id, :person_id, :user_id
  belongs_to :movie
  belongs_to :person
  belongs_to :user
end
