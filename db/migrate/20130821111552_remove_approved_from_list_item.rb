class RemoveApprovedFromListItem < ActiveRecord::Migration
  def up
    remove_column :list_items, :approved
  end

  def down
    add_column :list_items, :approved, :boolean
  end
end
