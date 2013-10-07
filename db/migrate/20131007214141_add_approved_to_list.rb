class AddApprovedToList < ActiveRecord::Migration
  def change
    add_column :lists, :approved, :boolean
  end
end
