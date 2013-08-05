class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title
      t.text :tagline
      t.text :overview
      t.integer :content_score
      t.boolean :approved

      t.timestamps
    end
  end
end
