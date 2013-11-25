class ImagesController < ApplicationController

  layout "seo"

  def show
    begin
      @image = @cache.get "static_images/#{params[:id]}"
      @media_tags = @cache.get "static_images/#{params[:id]}/media_tags"
      @media_keywords = @cache.get "static_images/#{params[:id]}/media_keywords"
      @movies = @cache.get "static_images/#{params[:id]}/movies"
      @people = @cache.get "static_images/#{params[:id]}/people"
      @companies = @cache.get "static_images/#{params[:id]}/companies"
      @keywords = @cache.get "static_images/#{params[:id]}/keywords"
    rescue
      @image = Image.where(id: params[:id], approved: true)
      if @image != []
        @image = @image.first
        @media_tags = @image.media_tags
        @media_keywords = @image.media_keywords
        get_tags
        get_keywords
      end
      if Rails.env.to_s == "production"
        @cache.set "static_images/#{params[:id]}", @image
        @cache.set "static_images/#{params[:id]}/media_tags", @media_tags
        @cache.set "static_images/#{params[:id]}/media_keywords", @media_keywords
        @cache.set "static_images/#{params[:id]}/movies", @movies
        @cache.set "static_images/#{params[:id]}/people", @people
        @cache.set "static_images/#{params[:id]}/companies", @companies
        @cache.set "static_images/#{params[:id]}/keywords", @keywords
      end
    end
  end

  def get_keywords
    @keywords = []
    if @media_keywords && @media_keywords.length  > 0
      @keywords = Keyword.find_all_by_id(@media_keywords.map(&:keyword_id))
    end
  end

  def get_tags
    @movies = []
    @people = []
    @companies = []
    if @media_tags && @media_tags.length  > 0
      movies = @media_tags.reject{ |tag| tag.taggable_type != "Movie" }
      people = @media_tags.reject{ |tag| tag.taggable_type != "Person" }
      companies = @media_tags.reject{ |tag| tag.taggable_type != "Company" }
      movie_ids = movies ? movies.map(&:taggable_id) : []
      person_ids = people ? people.map(&:taggable_id) : []
      company_ids = companies ? companies.map(&:taggable_id) : []
      @movies = Movie.find_all_by_id(movie_ids)
      @people = Person.find_all_by_id(person_ids)
      @companies = Company.find_all_by_id(company_ids)
    end
  end

end
