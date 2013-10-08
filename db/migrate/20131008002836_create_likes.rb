class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :likable_id
      t.string :likable_type
      t.integer :status
      t.integer :user_id
      t.string :temp_user_id

      t.timestamps
    end
  end
end
