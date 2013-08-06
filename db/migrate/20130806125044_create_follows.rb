class CreateFollows < ActiveRecord::Migration
  def change
    create_table :follows do |t|
      t.integer :user_id
      t.integer :followable_id
      t.string :followable_type
      t.boolean :approved

      t.timestamps
    end
  end
end
