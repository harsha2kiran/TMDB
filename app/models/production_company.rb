class ProductionCompany < ActiveRecord::Base
  attr_accessible :approved, :company_id, :movie_id, :user_id, :temp_user_id
  belongs_to :company
  belongs_to :user
  belongs_to :movie
  has_many :pending_items, :as => :approvable, :dependent => :destroy

  validates_presence_of :company_id, :movie_id
  validates_uniqueness_of :company_id, :scope => :movie_id

end
