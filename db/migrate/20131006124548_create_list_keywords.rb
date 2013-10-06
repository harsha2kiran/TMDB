class CreateListKeywords < ActiveRecord::Migration
  def change
    create_table :list_keywords do |t|
      t.integer :listable_id
      t.string :listable_type
      t.integer :keyword_id
      t.integer :user_id
      t.string :temp_user_id

      t.timestamps
    end
  end
end
