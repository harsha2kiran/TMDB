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

  def search

    @movies = Movie.where("lower(title) LIKE ? AND id = original_id", "%" + params[:term].downcase + "%").order("title")
    @people = Person.where("lower(name) LIKE ? AND id = original_id", "%" + params[:term].downcase + "%").order("name")
    @companies = Company.where("lower(company) LIKE ?", "%" + params[:term].downcase + "%").order("company")

    # @movies = Movie.search(params[:term])
    # @people = Person.search(params[:term])
    # @companies = Company.search(params[:term])

    @results = []
    @movies.each do |movie|
      @results << { id: movie.id, value: movie.title, type: "Movie" }
    end
    @people.each do |person|
      @results << { id: person.id, value: person.name, type: "Person" }
    end
    @companies.each do |company|
      @results << { id: company.id, value: company.company, type: "Company" }
    end
    render json: @results
  end

end
