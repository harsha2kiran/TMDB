class CreateListContents < ActiveRecord::Migration
  def change
    create_table :list_contents do |t|
      t.integer :list_id
      t.integer :listable_id
      t.string :listable_type
      t.boolean :approved

      t.timestamps
    end
  end
end
