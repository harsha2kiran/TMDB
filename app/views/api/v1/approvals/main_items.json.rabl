object @items
if @type == "Movie"
  attributes :id, :approved, :content_score, :locked, :overview, :tagline, :title, :user_id, :original_id, :popular, :temp_user_id, :created_at, :updated_at
elsif @type == "Person"
  attributes :id, :approved, :biography, :birthday, :day_of_death, :homepage, :imdb_id, :locked, :name, :place_of_birth, :user_id, :original_id, :temp_user_id, :created_at, :updated_at
end

