class Api::V1::CompaniesController < Api::V1::BaseController

  inherit_resources

  def search
    companies = Company.where("lower(company) LIKE ?", "%" + params[:term].downcase + "%")
    results = []
    companies.each do |company|
      results << { label: company.company, value: company.company, id: company.id }
    end
    render json: results
  end
end
