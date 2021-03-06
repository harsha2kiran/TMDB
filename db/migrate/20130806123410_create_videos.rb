class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :link
      t.integer :videable_id
      t.string :videable_type
      t.string :video_type
      t.string :quality
      t.boolean :link_active
      t.boolean :approved
      t.integer :priority

      t.timestamps
    end
  end
end
