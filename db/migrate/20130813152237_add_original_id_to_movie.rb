class AddOriginalIdToMovie < ActiveRecord::Migration
  def change
    add_column :movies, :original_id, :integer
    add_column :people, :original_id, :integer
  end
end
