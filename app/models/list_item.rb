class ListItem < ActiveRecord::Base
  attr_accessible :list_id, :listable_id, :listable_type
  belongs_to :listable, polymorphic: true

  validates :list_id, :uniqueness => { :scope => [:listable_type, :listable_id] }

end
