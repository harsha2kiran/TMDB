class CreateAlternativeTitles < ActiveRecord::Migration
  def change
    create_table :alternative_titles do |t|
      t.integer :movie_id
      t.string :alternative_title
      t.integer :language_id
      t.boolean :approved

      t.timestamps
    end
  end
end
