class Company < ActiveRecord::Base
  attr_accessible :approved, :company

  has_many :production_companies, :dependent => :destroy
  has_many :media_tags, :as => :taggable, :dependent => :destroy

  validates_presence_of :company
  validates :company, :uniqueness => { :case_sensitive => false }

  include PgSearch
  pg_search_scope :company_search, :against => [:company],
    using: {tsearch: {dictionary: "english", prefix: true}}

  def self.search(term)
    companies = Company.where(approved: true).company_search(term)
    companies = companies.uniq
  end

end
