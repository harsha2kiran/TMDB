class AlternativeName < ActiveRecord::Base
  attr_accessible :alternative_name, :approved, :person_id, :user_id, :temp_user_id
  belongs_to :person
  belongs_to :user
  has_many :pending_items, :as => :approvable, :dependent => :destroy

  validates_presence_of :alternative_name, :person_id
  validates :alternative_name, :uniqueness => { :scope => :person_id }

end
