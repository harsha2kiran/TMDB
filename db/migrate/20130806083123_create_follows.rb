class CreateFollows < ActiveRecord::Migration
  def change
    create_table :follows do |t|
      t.integer :user_id
      t.integer :item_id
      t.string :item_type
      t.boolean :approved

      t.timestamps
    end
  end
end
