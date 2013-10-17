class PeopleDatatable
  delegate :params, :h, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Person.count,
      iTotalDisplayRecords: Person.count, # movies.total_entries,
      aaData: data
    }
  end

private

  def data
    people.map do |person|
      [
        h(person.id),
        h(person.name),
        h(person.birthday),
        h(person.place_of_birth),
        h(person.imdb_id),
        "",
        ( (person.pending_items.length > 0) ? true : false ),
        h(person.approved)
      ]
    end
  end

  def people
    @people ||= fetch_people
  end

  def fetch_people
    people = Person.where("id = original_id").includes(:pending_items).order("#{sort_column} #{sort_direction}")
    people = people.page(page).per(per_page)
    if params[:sSearch].present?
      people = people.where("name like :search", search: "%#{params[:sSearch]}%")
    end
    people
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[name birthday place_of_birth imdb_id]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
