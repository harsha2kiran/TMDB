class PeopleController < ApplicationController

  layout "seo"

  def index
    begin
      cached_content = @cache.get "static_people"
      if cached_content
        @people = cached_content
      end
    rescue
      @people = Person.where("approved = TRUE AND original_id = id")
      if Rails.env.to_s == "production"
        @cache.set "static_people", @people.all
      end
    end
    @meta_title = "Movie Database"
    @meta_description = ""
    @meta_keywords = ""
  end

  def show
    begin
      @person = @cache.get "static_person_#{params[:id]}"
      @meta_title = @cache.get "static_person_meta_title_#{params[:id]}"
      @meta_description = @cache.get "static_person_meta_description_#{params[:id]}"
      @meta_keywords = @cache.get "static_person_meta_keywords_#{params[:id]}"
    rescue
      @person = Person.where(approved: true).find(params[:id], :include => [:alternative_names, :casts, :crews, :images, :videos, :views, :follows, :person_social_apps, :tags])
      @meta_title = @person.meta_title
      @meta_description = @person.meta_description
      @meta_keywords = @person.meta_keywords
      if Rails.env.to_s == "production"
         @cache.set "static_person_#{params[:id]}", @person
         @cache.set "static_person_meta_title_#{params[:id]}", @meta_title
         @cache.set "static_person_meta_description_#{params[:id]}", @meta_description
         @cache.set "static_person_meta_keywords_#{params[:id]}", @meta_keywords
      end
    end
  end

end
