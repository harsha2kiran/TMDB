class Api::V1::ProductionCompaniesController < Api::V1::BaseController

  inherit_resources

  def index
    @production_companies = ProductionCompany.find(:all, include: [:company])
    @companies = Company.find_all_by_id @production_companies.map(&:company_id)
  end

end
