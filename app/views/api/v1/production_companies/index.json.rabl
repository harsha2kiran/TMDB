object @production_companies
attributes :id, :approved, :company_id, :movie_id, :created_at, :updated_at
node(:company){ |production_company|
  Company.find production_company.company_id
}
