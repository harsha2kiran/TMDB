class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.integer :taggable_id
      t.string :taggable_type
      t.integer :person_id
      t.boolean :approved

      t.timestamps
    end
  end
end
