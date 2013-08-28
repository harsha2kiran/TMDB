class AddApprovedToGenre < ActiveRecord::Migration
  def change
    add_column :genres, :approved, :boolean
  end
end
