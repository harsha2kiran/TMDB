class CreateMediaTags < ActiveRecord::Migration
  def change
    create_table :media_tags do |t|
      t.integer :mediable_id
      t.string :mediable_type
      t.integer :taggable_id
      t.string :taggable_type
      t.integer :user_id
      t.string :temp_user_id

      t.timestamps
    end
  end
end
