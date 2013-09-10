object @genre
attributes :id, :genre, :created_at, :updated_at
if @genre
  node(:movies) { |genre|
    genre.movies
  }
  child :movies do
    attributes :id, :title
    node(:images){ |movie|
      movie.images.select {|s| s.is_main_image == true }[0]
    }
  end
  node(:follows) { |genre| genre.follows }
end
