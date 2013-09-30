object @alternative_titles
attributes :id, :alternative_title, :approved, :language_id, :movie_id, :created_at, :updated_at, :user_id, :temp_user_id
if @original_movie
  node(:language){ |alternative_title|
    @languages.select {|s| alternative_title.language_id == s.id }[0]
  }
else
  node(:language){ |alternative_title|
    @languages.select {|s| alternative_title.language_id == s.id && s.approved == true }[0]
  }
end
