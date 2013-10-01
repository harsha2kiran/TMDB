class Api::V1::SearchController < ApplicationController

  def search
    @movies = Movie.search(params[:term])
    @people = Person.search(params[:term])

    @results = []
    @movies.each do |movie|
      @results << Hash.new(id: movie.id, value: movie.title, type: "Movie")
    end
    @people.each do |person|
      @results << Hash.new(id: person.id, value: person.name, type: "Person")
    end

    # if params[:for_list]
    #   @images = Image.search(params[:term])
    #   @videos = Video.search(params[:term])
    #   @images.each do |image|
    #     @results << Hash.new(id: image.id, value: image.title, type: "Image")
    #   end
    #   @videos.each do |video|
    #     @results << Hash.new(id: video.id, value: video.title, type: "Video")
    #   end
    # end
    @results
  end

end
