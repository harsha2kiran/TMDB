class CreateMovieLanguages < ActiveRecord::Migration
  def change
    create_table :movie_languages do |t|
      t.integer :movie_id
      t.integer :language_id
      t.boolean :approved

      t.timestamps
    end
  end
end
