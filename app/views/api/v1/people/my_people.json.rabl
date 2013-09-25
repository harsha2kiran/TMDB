object @people
attributes :id, :original_id, :user_id, :approved, :biography, :birthday, :day_of_death, :homepage, :imdb_id, :locked, :name, :place_of_birth, :created_at, :updated_at
if @all
  node(:images) { |person| person.images }
else
  node(:images) { |person|
    if @current_api_user
      person.images.select {|s| (s.approved == true || s.user_id == @current_api_user.id) }
    else
      person.images.select {|s| (s.approved == true || s.temp_user_id == params[:temp_user_id]) }
    end
  }
end
