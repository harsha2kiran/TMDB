class Api::V1::CountriesController < Api::V1::BaseController

  inherit_resources

  def search
    countries = Country.where("lower(country) LIKE ?", "%" + params[:term].downcase + "%").order("id ASC")
    results = []
    arr = []
    countries.each do |country|
      unless arr.include?(country.country.downcase)
        arr << country.country.downcase
        results << { label: country.country, value: country.country, id: country.id }
      end
    end
    render json: results
  end

end
