class Report < ActiveRecord::Base
  attr_accessible :reportable_id, :reportable_type, :user_id, :temp_user_id
  belongs_to :reportable, polymorphic: true
end
