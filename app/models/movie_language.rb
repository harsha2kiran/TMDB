class MovieLanguage < ActiveRecord::Base
  attr_accessible :approved, :language_id, :movie_id, :user_id, :temp_user_id
  belongs_to :language
  belongs_to :movie
  belongs_to :user
  has_many :pending_items, :as => :approvable, :dependent => :destroy

  validates_presence_of :language_id, :movie_id
  validates_uniqueness_of :language_id, :scope => :movie_id

end
