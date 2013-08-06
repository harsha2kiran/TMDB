class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :item_id
      t.string :item_type
      t.string :title
      t.string :image_file
      t.string :image_type
      t.boolean :is_main_image
      t.boolean :approved

      t.timestamps
    end
  end
end
