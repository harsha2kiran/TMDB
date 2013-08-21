class Api::V1::PersonSocialAppsController < Api::V1::BaseController

  inherit_resources

  def index
    @person_social_apps = PersonSocialApp.find(:all, include: [:social_app])
    @social_apps = SocialApp.find_all_by_id @person_social_apps.map(&:social_app_id)
    @people = Person.find_all_by_id @person_social_apps.map(&:person_id)
  end

end
