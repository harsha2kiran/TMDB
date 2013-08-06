class CreateListContents < ActiveRecord::Migration
  def change
    create_table :list_contents do |t|
      t.integer :list_id
      t.integer :item_id
      t.string :item_type
      t.boolean :approved

      t.timestamps
    end
  end
end
