object @production_companies
attributes :id, :approved, :company_id, :movie_id, :created_at, :updated_at
node(:company){ |production_company|
  @companies.select {|s| production_company.company_id == s.id }[0]
}
