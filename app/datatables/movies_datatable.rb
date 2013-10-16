class MoviesDatatable
  delegate :params, :h, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Movie.count,
      iTotalDisplayRecords: Movie.count, # movies.total_entries,
      aaData: data
    }
  end

private

  def data
    movies.map do |movie|
      [
        h(movie.id),
        h(movie.title),
        h(movie.tagline),
        h(movie.overview),
        h(movie.content_score),
        "",
        ( (movie.pending_items.length > 0) ? true : false ),
        h(movie.approved)
      ]
    end
  end

  def movies
    @movies ||= fetch_movies
  end

  def fetch_movies
    movies = Movie.where("id = original_id").includes(:pending_items).order("#{sort_column} #{sort_direction}")
    movies = movies.page(page).per(per_page)
    if params[:sSearch].present?
      movies = movies.where("title like :search", search: "%#{params[:sSearch]}%")
    end
    movies
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
