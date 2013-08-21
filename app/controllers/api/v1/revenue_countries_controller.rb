class Api::V1::RevenueCountriesController < Api::V1::BaseController

  inherit_resources

  def index
    @revenue_countries = RevenueCountry.find(:all, include: [:country])
    @countries = Country.find_all_by_id @revenue_countries.map(&:country_id)
  end

end
