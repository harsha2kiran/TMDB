class List < ActiveRecord::Base
  attr_accessible :description, :title, :user_id, :list_type, :temp_user_id
  belongs_to :user
  has_many :list_items, :dependent => :destroy
  has_many :follows, :as => :followable
end
