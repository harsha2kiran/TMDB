class CreateViews < ActiveRecord::Migration
  def change
    create_table :views do |t|
      t.string :viewable_type
      t.integer :viewable_id
      t.integer :views_count

      t.timestamps
    end
  end
end
