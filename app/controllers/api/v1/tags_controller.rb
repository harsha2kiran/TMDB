class Api::V1::TagsController < Api::V1::BaseController

  inherit_resources

  def index
    @tags = Tag.find(:all, include: [:taggable, :person])
    @movies = Movie.find_all_by_id @tags.map(&:taggable_id)
    @people = Person.find_all_by_id @tags.map(&:person_id)
  end

  def show
    @tag = Tag.find(params[:id])
    @movies = Movie.find_all_by_id @tag.taggable_id
    @people = Person.find_all_by_id @tag.person_id
  end

end
