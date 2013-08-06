class CreateMovieKeywords < ActiveRecord::Migration
  def change
    create_table :movie_keywords do |t|
      t.integer :keyword_id
      t.integer :movie_id
      t.boolean :approved

      t.timestamps
    end
  end
end
