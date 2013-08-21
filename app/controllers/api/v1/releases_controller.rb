class Api::V1::ReleasesController < Api::V1::BaseController

  inherit_resources

  def index
    @releases = Release.find(:all, include: [:country])
    @countries = Country.find_all_by_id @releases.map(&:country_id)
  end

end
