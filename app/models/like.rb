class Like < ActiveRecord::Base
  attr_accessible :likable_id, :likable_type, :status, :temp_user_id, :user_id

  belongs_to :likable, polymorphic: true
  belongs_to :user

end
