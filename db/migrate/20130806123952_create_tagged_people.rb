class CreateTaggedPeople < ActiveRecord::Migration
  def change
    create_table :tagged_people do |t|
      t.integer :taggable_id
      t.string :taggable_type
      t.boolean :approved

      t.timestamps
    end
  end
end
