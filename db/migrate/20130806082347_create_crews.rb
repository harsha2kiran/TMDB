class CreateCrews < ActiveRecord::Migration
  def change
    create_table :crews do |t|
      t.integer :movie_id
      t.integer :person_id
      t.string :job
      t.boolean :approved

      t.timestamps
    end
  end
end
