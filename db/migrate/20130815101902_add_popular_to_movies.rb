class AddPopularToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :popular, :integer
  end
end
