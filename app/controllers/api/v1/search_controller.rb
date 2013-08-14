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
    @results
  end

end
