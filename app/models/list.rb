class List < ActiveRecord::Base
  attr_accessible :description, :title, :user_id, :list_type
  belongs_to :user
  has_many :list_items, :dependent => :destroy
end
