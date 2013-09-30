object @production_companies
attributes :id, :approved, :company_id, :movie_id, :created_at, :updated_at, :user_id, :temp_user_id
if @original_movie
  node(:company){ |production_company|
    @companies.select {|s| production_company.company_id == s.id }[0]
  }
else
  node(:company){ |production_company|
    @companies.select {|s| production_company.company_id == s.id && s.approved == true }[0]
  }
end
