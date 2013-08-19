class Api::V1::SocialAppsController < Api::V1::BaseController

  inherit_resources

  def search
    social_apps = SocialApp.where("lower(social_app) LIKE ?", "%" + params[:term].downcase + "%")
    results = []
    social_apps.each do |social_app|
      results << { label: social_app.social_app, value: social_app.social_app, id: social_app.id }
    end
    render json: results
  end

end
