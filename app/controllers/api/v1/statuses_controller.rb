class Api::V1::StatusesController < Api::V1::BaseController

  inherit_resources

  def search
    statuses = Status.where("lower(status) LIKE ?", "%" + params[:term].downcase + "%").order("id ASC")
    results = []
    arr = []
    statuses.each do |status|
      unless arr.include?(status.status.downcase)
        arr << status.status.downcase
        results << { label: status.status, value: status.status, id: status.id }
      end
    end
    render json: results
  end

end
