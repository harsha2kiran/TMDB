module MoviesHelper

  def collect_popular(movies, people)
    items = []
    movies.each do |item|
      items << { id: item.id, title: item.title, popular: item.popular, images: item.images, type: "Movie" }
    end
    people.each do |item|
      items << { id: item.id, title: item.name, popular: item.popular, images: item.images, type: "Person" }
    end
    items.sort! { |a,b| a[:popular] <=> b[:popular] }
    items
  end

  def filter_results(movies)
    original_ids = []
    movies.each_with_index do |movie, i|
      if original_ids.include?(movie.original_id)
        movies[i] = ""
      else
        original_ids << movie.original_id
      end
    end
    movies.reject! { |c| c == "" }
    movies
  end

end
