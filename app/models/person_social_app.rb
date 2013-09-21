class PersonSocialApp < ActiveRecord::Base
  attr_accessible :approved, :person_id, :profile_link, :social_app_id, :user_id, :temp_user_id
  belongs_to :social_app
  belongs_to :person
  belongs_to :user

  validates_presence_of :person_id, :profile_link, :social_app_id
  validates :profile_link, :uniqueness => { :scope => [:person_id, :social_app_id], :case_sensitive => false }

end
