class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :company
      t.boolean :approved

      t.timestamps
    end
  end
end
