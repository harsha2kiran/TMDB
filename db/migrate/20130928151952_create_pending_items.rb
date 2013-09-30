class CreatePendingItems < ActiveRecord::Migration
  def change
    create_table :pending_items do |t|
      t.integer :pendable_id
      t.string :pendable_type
      t.integer :user_id
      t.string :temp_user_id

      t.timestamps
    end
  end
end
