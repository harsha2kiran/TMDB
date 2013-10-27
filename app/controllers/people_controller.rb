class PeopleController < ActionController::Base

  layout "seo"

  def index
    @people = Person.where("approved = TRUE AND original_id = id")
    @meta_title = "Movie Database"
    @meta_description = ""
    @meta_keywords = ""
  end

  def show
    @person = Person.where(approved: true).find(params[:id])
    @meta_title = @person.meta_title
    @meta_description = @person.meta_description
    @meta_keywords = @person.meta_keywords
  end

end
