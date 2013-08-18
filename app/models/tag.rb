class Tag < ActiveRecord::Base
  attr_accessible :approved, :person_id, :taggable_id, :taggable_type, :user_id
  belongs_to :taggable, polymorphic: true
  belongs_to :person
  belongs_to :user

  validates_presence_of :person_id, :taggable_id, :taggable_type, :user_id

end
