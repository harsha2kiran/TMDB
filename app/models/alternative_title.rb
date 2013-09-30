class AlternativeTitle < ActiveRecord::Base
  attr_accessible :alternative_title, :approved, :language_id, :movie_id, :user_id, :temp_user_id

  belongs_to :movie
  belongs_to :language
  belongs_to :user
  has_many :pending_items, :as => :approvable, :dependent => :destroy

  validates_presence_of :alternative_title, :language_id, :movie_id
  validates :alternative_title, :uniqueness => { :scope => [:language_id, :movie_id], :case_sensitive => false }

end
