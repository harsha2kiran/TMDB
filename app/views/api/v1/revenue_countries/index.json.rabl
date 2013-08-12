object @revenue_countries
attributes :id, :approved, :country_id, :movie_id, :revenue, :created_at, :updated_at
node(:country){ |revenue_country|
  Country.find revenue_country.country_id
}
