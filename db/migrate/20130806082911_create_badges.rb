class CreateBadges < ActiveRecord::Migration
  def change
    create_table :badges do |t|
      t.string :badge
      t.integer :min_points

      t.timestamps
    end
  end
end
