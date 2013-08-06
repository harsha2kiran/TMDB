class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.text :biography
      t.datetime :birthday
      t.datetime :day_of_death
      t.string :place_of_birth
      t.string :homepage
      t.string :imdb_id
      t.boolean :approved
      t.hstore :locked

      t.timestamps
    end
  end
end
