class CreateAlternativeNames < ActiveRecord::Migration
  def change
    create_table :alternative_names do |t|
      t.integer :person_id
      t.string :alternative_name
      t.boolean :approved

      t.timestamps
    end
  end
end
