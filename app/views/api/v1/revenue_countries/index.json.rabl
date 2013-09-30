object @revenue_countries
attributes :id, :approved, :country_id, :movie_id, :revenue, :created_at, :updated_at, :user_id, :temp_user_id
node(:country){ |revenue_country|
  @countries.select {|s| revenue_country.country_id == s.id }[0]
}
