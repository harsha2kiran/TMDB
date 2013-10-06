class CreateListTags < ActiveRecord::Migration
  def change
    create_table :list_tags do |t|
      t.integer :listable_id
      t.string :listable_type
      t.integer :taggable_id
      t.string :taggable_type
      t.integer :user_id
      t.string :temp_user_id

      t.timestamps
    end
  end
end
