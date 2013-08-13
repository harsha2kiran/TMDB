class AlternativeName < ActiveRecord::Base
  attr_accessible :alternative_name, :approved, :person_id, :user_id
  belongs_to :people
end
