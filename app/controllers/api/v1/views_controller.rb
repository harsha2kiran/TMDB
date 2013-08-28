class Api::V1::ViewsController < Api::V1::BaseController

  inherit_resources

  def create

    if current_api_user
      user_id = current_api_user.id
    else
      user_id = 0
    end

    type = params[:view][:viewable_type]
    id = params[:view][:viewable_id]
    if user_id != 0
      views = View.where(viewable_type: type, viewable_id: id, user_id: user_id)
      unless views.count > 0
        v = View.new(viewable_type: type, viewable_id: id, views_count: 1, user_id: user_id)
        v.save!
      end
    else
      v = View.new(viewable_type: type, viewable_id: id, views_count: 1, user_id: user_id)
      v.save!
    end

    # if v.count > 0
    #   v = v.first
    #   if current_api_user
    #     if v.user_id != user_id
    #       v.views_count = v.views_count + 1
    #       v.save!
    #     end
    #   else
    #     v.views_count = v.views_count + 1
    #     v.save!
    #   end
    # else
    #   v = View.new(viewable_type: type, viewable_id: id, views_count: 1, user_id: user_id)
    #   v.save!
    # end
    render nothing: true
  end

end
