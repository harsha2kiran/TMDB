class PendingItem < ActiveRecord::Base
  attr_accessible :pendable_id, :pendable_type, :approvable_id, :approvable_type, :temp_user_id, :user_id
  belongs_to :pendable, polymorphic: true
  belongs_to :approvable, polymorphic: true
end
