class CreateCasts < ActiveRecord::Migration
  def change
    create_table :casts do |t|
      t.integer :movie_id
      t.integer :person_id
      t.string :character
      t.boolean :approved

      t.timestamps
    end
  end
end
