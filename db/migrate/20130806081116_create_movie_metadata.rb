class CreateMovieMetadata < ActiveRecord::Migration
  def change
    create_table :movie_metadata do |t|
      t.integer :movie_id
      t.integer :movie_type_id
      t.integer :budget
      t.integer :runtime
      t.integer :status_id
      t.string :imdb_id
      t.string :homepage
      t.boolean :approved

      t.timestamps
    end
  end
end
