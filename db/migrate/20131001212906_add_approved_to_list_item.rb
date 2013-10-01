class AddApprovedToListItem < ActiveRecord::Migration
  def change
    add_column :list_items, :approved, :boolean
  end
end
