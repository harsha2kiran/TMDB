class Api::V1::ViewsController < Api::V1::BaseController

  inherit_resources

  def create
    type = params[:view][:viewable_type]
    id = params[:view][:viewable_id]
    v = View.where(viewable_type: type, viewable_id: id)
    if v.count > 0
      v = v.first
      v.views_count = v.views_count + 1
      v.save!
    else
      v = View.new(viewable_type: type, viewable_id: id, views_count: 1)
      v.save!
    end
    render nothing: true
  end

end
