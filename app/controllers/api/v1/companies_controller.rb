class Api::V1::CompaniesController < Api::V1::BaseController

  inherit_resources

  def search
    companies = Company.where("lower(company) LIKE ?", "%" + params[:term].downcase + "%").order("id ASC")
    results = []
    arr = []
    companies.each do |company|
      unless arr.include?(company.company.downcase)
        arr << company.company.downcase
        results << { label: company.company, value: company.company, id: company.id }
      end
    end
    render json: results
  end
end
