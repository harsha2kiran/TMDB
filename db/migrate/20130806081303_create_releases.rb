class CreateReleases < ActiveRecord::Migration
  def change
    create_table :releases do |t|
      t.integer :movie_id
      t.boolean :primary
      t.integer :country_id
      t.datetime :release_date
      t.string :certification
      t.boolean :confirmed
      t.boolean :approved

      t.timestamps
    end
  end
end
