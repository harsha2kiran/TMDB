class Api::V1::ApprovalsController < Api::V1::BaseController

  respond_to :json

  def mark
    respond_to do |format|
      type = params[:type]
      mark = params[:mark]
      if ["admin", "moderator"].include?(current_api_user.user_type)
        if ["Movie", "Person"].include?(type)
          original_id = params[:original_id]
          approved_id = params[:approved_id]

          if original_id == approved_id
            original_record = type.classify.constantize.find(original_id)
            original_record.approved = mark
            original_record.save
            format.json { render json: original_record }
          else
            # get currently active item and duplicate it for backup
            original_record = type.classify.constantize.where(id: original_id)
            if original_record.count > 0
              original_record = original_record.first
              backup_status = backup_original(original_record)

              # get the approved record
              approved_record = type.classify.constantize.where(id: approved_id)
              if approved_record.count > 0
                approved_record = approved_record.first
                approved_values = approved_record.attributes
                approved_values  = approved_values.except("id", "created_at", "updated_at", "meta_title", "meta_keywords", "meta_description")
                approved_values["approved"] = mark
                unless approved_values["user_id"]
                  approved_values["user_id"] = current_api_user.id
                end

                # update currently active item with new approved values
                original_record.approved = true
                if original_record.update_attributes(approved_values)
                  if approved_record.user_id
                    user = User.find approved_record.user_id
                    add_points_to_user(user)
                    add_badges_to_user(user)
                  end
                  # update foreign keys (ids) on each related table according to item type
                  approved_record.destroy
                  format.json { render json: original_record }
                else
                  format.json { render :json => "Error approving content.", :status => :unprocessable_entity }
                end
              else
                if backup_status
                  type.classify.constantize.last.destroy
                end
                format.json { render :json => "Error approving content not found.", :status => :unprocessable_entity }
              end
            else
              format.json { render :json => "Error original content not found.", :status => :unprocessable_entity }
            end
          end
        else
          id = params[:approved_id]
          if type == "MovieMetadata"
            record = MovieMetadata.find id
          else
            record = type.classify.constantize.find id
          end
          record.approved = mark
          if record.save
            if mark == "true"
              approve_master_value(type, record)
            end
            format.json { render json: record }
          else
            format.json { render :json => "Error approving content.", :status => :unprocessable_entity }
          end
        end
      else
        format.json { render :json => "Error: current user is not admin or moderator.", :status => :unprocessable_entity }
      end
    end
  end

  def add_remove_main_pending
    user_id = params[:user_id] if params[:user_id]
    temp_user_id = params[:temp_user_id] if params[:temp_user_id]
    original_id = params[:original_id]
    type = params[:type]
    mark = params[:mark]

    if mark.to_s == "true"
      pending = PendingItem.where(approvable_id: original_id, approvable_type: type.classify, pendable_id: original_id, pendable_type: type.classify)
      if user_id != "" && user_id != "undefined"
        pending = pending.where(user_id: user_id)
      elsif temp_user_id != "" && temp_user_id != "undefined"
        pending = pending.where(temp_user_id: temp_user_id)
      end
      pending.destroy_all
    else
      pending = PendingItem.new(approvable_id: original_id, approvable_type: type.classify, pendable_id: original_id, pendable_type: type.classify)
      if user_id != "" && user_id != "undefined"
        pending.user_id = user_id
      elsif temp_user_id != "" && temp_user_id != "undefined"
        pending.temp_user_id = temp_user_id
      end
      pending.save
    end
    render nothing: true
  end

  def add_remove_pending
    user_id = params[:user_id] if params[:user_id]
    temp_user_id = params[:temp_user_id] if params[:temp_user_id]
    approvable_id = params[:approvable_id]
    approvable_type = params[:approvable_type]
    pendable_id = params[:pendable_id]
    pendable_type = params[:pendable_type]

    pending = []

    # check if pending item exist

    if ["Cast", "Crew", "Tag"].include?(approvable_type)
      pending = PendingItem.where(approvable_id: approvable_id, approvable_type: approvable_type)
    else
      pending = PendingItem.where(pendable_type: pendable_type, pendable_id: pendable_id, approvable_id: approvable_id, approvable_type: approvable_type)
    end

    if user_id != "" && user_id != "undefined"
      pending = pending.where(user_id: user_id)
    elsif temp_user_id != "" && temp_user_id != "undefined"
      pending = pending.where(temp_user_id: temp_user_id)
    end

    # if doesn't exist and user is unapproving
    if params[:approval_type] == "unapprove" && pending.count == 0
      if user_id != "" && user_id != "undefined"
        pending = PendingItem.new(pendable_type: pendable_type, pendable_id: pendable_id, approvable_id: approvable_id, approvable_type: approvable_type, user_id: user_id)
      else
        pending = PendingItem.new(pendable_type: pendable_type, pendable_id: pendable_id, approvable_id: approvable_id, approvable_type: approvable_type, temp_user_id: temp_user_id)
      end
      pending.save
    elsif params[:approval_type] == "approve" && pending.count > 0
      pending.destroy_all
      pending = PendingItem.where(approvable_id: params[:additional_id], approvable_type: params[:additional_type], pendable_id: params[:additional_id], pendable_type: params[:additional_type])
      pending.destroy_all
    end

    if ["Cast", "Crew", "Tag"].include?(approvable_type)
      if params[:approval_type] == "unapprove" && params[:additional_id] && params[:additional_type] && params[:additional_id] != "" && params[:additional_type] != ""
        if user_id && user_id != "undefined"
          p = PendingItem.new(pendable_type: params[:additional_type], pendable_id: params[:additional_id], approvable_id: approvable_id, approvable_type: approvable_type, user_id: user_id)
        else
          p = PendingItem.new(pendable_type: params[:additional_type], pendable_id: params[:additional_id], approvable_id: approvable_id, approvable_type: approvable_type, temp_user_id: temp_user_id)
        end
        p.save
        pending = PendingItem.new(approvable_id: params[:additional_id], approvable_type: params[:additional_type], pendable_id: params[:additional_id], pendable_type: params[:additional_type])
        pending.save
      end
    end

    render nothing: true
  end

  def main_items
    @type = params[:type]
    if @type == "Movie"
      value = MoviesDatatable.new(view_context)
    elsif @type == "Person"
      value = PeopleDatatable.new(view_context)
    elsif @type == "Gallery" || @type == "Channel" || @type == "List"
      value = ListsDatatable.new(view_context, @type)
    elsif @type == "User"
      value = UsersDatatable.new(view_context)
    end
    respond_to do |format|
      format.html
      format.json { render json: value }
    end
  end

  def main_item
    @type = params[:type]
    @id = params[:id]
    @item = @type.classify.constantize.where("original_id = ?", @id).order("created_at")
    render "main_item"
  end

  def items
    @type = params[:type]
    if @type == "MovieMetadata"
      @items = MovieMetadata.order("created_at")
    else
      @items = @type.classify.constantize.order("created_at")
    end
    render "items"
  end

  def item
    @type = params[:type]
    @id = params[:id]
    @item = @type.classify.constantize.where("id = ?", @id).order("created_at")
    render "item"
  end

  def inline_edit
    model = params[:model].classify.constantize
    movie = model.find params[:id]
    movie[params[:column].to_sym] = params[:value]
    movie.save
    render text: params[:value]
  end

  private

  def approve_master_value(type, record)
    type = type.classify
    if ["MovieGenre", "MovieKeyword", "AlternativeTitle", "MovieLanguage", "Cast", "Crew", "ProductionCompany", "Tag", "PersonSocialApp"].include?(type)
      case type
      when "MovieGenre"
        item = Genre.find(record.genre_id)
      when "MovieKeyword"
        item = Keyword.find(record.keyword_id)
      when "AlternativeTitle"
        item = Language.find(record.language_id)
      when "MovieLanguage"
        item = Language.find(record.language_id)
      when "Cast"
        person = Person.find(record.person_id)
        movie = Movie.find(record.movie_id)
      when "Crew"
        person = Person.find(record.person_id)
        movie = Movie.find(record.movie_id)
      when "Tag"
        person = Person.find(record.person_id)
        if record.taggable_type == "Movie"
          movie = Movie.find(record.taggable_id)
        end
      when "ProductionCompany"
        item = Company.find(record.company_id)
      when "PersonSocialApp"
        item = SocialApp.find(record.social_app_id)
      end
      if item
        item.approved = true
        item.save
      else
        person.approved = true
        movie.approved = true
        person.save
        movie.save
      end
    end
  end

  def add_points_to_user(user)
    unless user.points
      user.points = 0
    end
    user.points = user.points + 10
    user.save
  end

  def add_badges_to_user(user)
    badges = Badge.where("min_points < ? OR min_points = ?", user.points, user.points)
    user_badges_ids = user.badges.map(&:id)
    badges.each do |badge|
      unless user_badges_ids.include?(badge.id)
        user.badges << badge
      end
    end
  end

  def backup_original(original_record)
    copy_record = original_record.clone
    copy_record.approved = false
    copy_values = copy_record.attributes
    copy_values = copy_values.except("id", "created_at", "updated_at", "temp_user_id")
    new_copy_record = original_record.class.name.classify.constantize.new(copy_values)
    if new_copy_record.save
      true
    else
      false
    end
  end

end
