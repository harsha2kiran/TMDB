class ProductionCompany < ActiveRecord::Base
  attr_accessible :approved, :company_id, :movie_id
  belongs_to :company
  belongs_to :movie
end
