class AddThumbnail2Thumbnail3ToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :thumbnail2, :string
    add_column :videos, :thumbnail3, :string
  end
end
