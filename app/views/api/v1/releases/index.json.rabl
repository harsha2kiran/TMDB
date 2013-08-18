object @releases
attributes :id, :approved, :certification, :confirmed, :country_id, :movie_id, :primary, :release_date,:created_at, :updated_at
node(:country){ |release|
  @countries.select {|s| release.country_id == s.id }[0]
}
