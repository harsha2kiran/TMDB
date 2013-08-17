class PersonSocialApp < ActiveRecord::Base
  attr_accessible :approved, :person_id, :profile_link, :social_app_id, :user_id
  belongs_to :social_app
  belongs_to :person
  belongs_to :user
end
