class PersonSocialApps < ActiveRecord::Base
  attr_accessible :approved, :person_id, :profile_link, :social_app_id
end
