class CreateViews < ActiveRecord::Migration
  def change
    create_table :views do |t|
      t.string :item_type
      t.integer :item_id
      t.integer :views_count

      t.timestamps
    end
  end
end
