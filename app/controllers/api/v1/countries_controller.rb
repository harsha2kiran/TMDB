class Api::V1::CountriesController < Api::V1::BaseController

  inherit_resources

  def search
    countries = Country.where("lower(country) LIKE ?", "%" + params[:term].downcase + "%")
    results = []
    countries.each do |country|
      results << { label: country.country, value: country.country, id: country.id }
    end
    render json: results
  end

end
