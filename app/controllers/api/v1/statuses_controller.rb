class Api::V1::StatusesController < Api::V1::BaseController

  inherit_resources

  def search
    statuses = Status.where("status LIKE ?", "%" + params[:term].downcase + "%")
    results = []
    statuses.each do |status|
      results << { label: status.status, value: status.status, id: status.id }
    end
    render json: results
  end

end
