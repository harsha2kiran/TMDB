class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :item_type
      t.integer :item_id
      t.integer :user_id

      t.timestamps
    end
  end
end
