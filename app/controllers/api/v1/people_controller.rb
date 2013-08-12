class Api::V1::PeopleController < Api::V1::BaseController

  inherit_resources

  def index
    # current_user = User.where(user_type: "admin").first
    if ["admin", "moderator"].include?(current_user.user_type) && params[:moderate]
      @people = Person.all
      @all = true
    else
      @people = Person.where(approved: true)
      @all = false
    end
  end

  def show
    # current_user = User.where(user_type: "admin").first
    if ["admin", "moderator"].include?(current_user.user_type) && params[:moderate]
      @person = Person.find params[:id]
      @all = true
    else
      @person = Person.where(approved: true).find(params[:id])
      @all = false
    end
  end

end
