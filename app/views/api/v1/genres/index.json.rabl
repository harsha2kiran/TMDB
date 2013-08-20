object @genres
attributes :id, :genre, :created_at, :updated_at
node(:movies) { |genre|
  genre.movies
}
child :movies do
  attributes :id, :title
  node(:images){ |movie|
    movie.images.select {|s| s.is_main_image == true }[0]
  }
end
