class List < ActiveRecord::Base
  attr_accessible :description, :title, :user_id, :list_type, :temp_user_id, :approved
  belongs_to :user
  has_many :list_items, :dependent => :destroy
  has_many :follows, :as => :followable
  has_many :pending_items, :as => :pendable, :dependent => :destroy

end
