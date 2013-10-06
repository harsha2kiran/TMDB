class CreateMediaKeywords < ActiveRecord::Migration
  def change
    create_table :media_keywords do |t|
      t.integer :mediable_id
      t.string :mediable_type
      t.integer :keyword_id
      t.integer :user_id
      t.string :temp_user_id

      t.timestamps
    end
  end
end
