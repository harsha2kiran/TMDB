class CreateRevenueCountries < ActiveRecord::Migration
  def change
    create_table :revenue_countries do |t|
      t.integer :country_id
      t.integer :movie_id
      t.integer :revenue
      t.boolean :approved

      t.timestamps
    end
  end
end
