collection @movies, :object_root => false
node(:id){ |movie| movie[:id] }
node(:title){ |movie| movie[:title] }
node(:popular){ |movie| movie[:popular] }
node(:image) { |movie| movie.images.where(is_main_image: true).first }
