class ListsDatatable
  delegate :params, :h, :link_to, :number_to_currency, to: :@view

  def initialize(view, type)
    @type = type
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: List.count,
      iTotalDisplayRecords: List.count, # lists.total_entries,
      aaData: data
    }
  end

private

  def data
    lists.map do |list|
      [
        h(list.id),
        h(list.title),
        h(list.description),
        # ( (list.pending_items.length > 0) ? true : false ),
        h(list.approved)
      ]
    end
  end

  def lists
    @lists ||= fetch_lists
  end

  def fetch_lists
    lists = List.where("list_type = ?", @type.downcase).order("#{sort_column} #{sort_direction}")
    lists = lists.page(page).per(per_page)
    if params[:sSearch].present?
      lists = lists.where("title like :search", search: "%#{params[:sSearch]}%")
    end
    lists
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[title tagline overview content_score]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
