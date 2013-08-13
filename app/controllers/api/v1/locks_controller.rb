class Api::V1::LocksController < ApplicationController

  def mark
    respond_to do |format|
      #TODO remove next line
      current_user = User.where(user_type: "admin").first
      id = params[:id]
      type = params[:type]
      field = params[:field]
      if current_user.user_type == "admin" && ["Movie", "Person"].include?(type)
        item = type.classify.constantize.find id
        if item.locked == {}
          item.locked["locked"] = "[]"
        end

        fields = eval(item.locked["locked"])

        unless fields.include?(field)
          fields << field
        end

        item.locked["locked"] = fields

        if item.save
          format.json { render json: item }
        else
          format.json { render :json => "Error saving item.", :status => :unprocessable_entity }
        end
      else
        format.json { render :json => "Error: current user is not admin or moderator.", :status => :unprocessable_entity }
      end
    end
  end

  def unmark
    respond_to do |format|
      #TODO remove next line
      current_user = User.where(user_type: "admin").first
      id = params[:id]
      type = params[:type]
      field = params[:field]
      if current_user.user_type == "admin" && ["Movie", "Person"].include?(type)
        item = type.classify.constantize.find id
        if item.locked == {}
          item.locked["locked"] = "[]"
        end

        fields = eval(item.locked["locked"])

        if fields.include?(field)
          fields.delete(field)
        end

        item.locked["locked"] = fields

        if item.save
          format.json { render json: item }
        else
          format.json { render :json => "Error saving item.", :status => :unprocessable_entity }
        end
      else
        format.json { render :json => "Error: current user is not admin or moderator.", :status => :unprocessable_entity }
      end
    end
  end

end
