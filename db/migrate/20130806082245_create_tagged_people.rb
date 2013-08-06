class CreateTaggedPeople < ActiveRecord::Migration
  def change
    create_table :tagged_people do |t|
      t.integer :item_id
      t.string :item_type
      t.boolean :approved

      t.timestamps
    end
  end
end
