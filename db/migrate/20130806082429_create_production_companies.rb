class CreateProductionCompanies < ActiveRecord::Migration
  def change
    create_table :production_companies do |t|
      t.integer :movie_id
      t.integer :company_id
      t.boolean :approved

      t.timestamps
    end
  end
end
