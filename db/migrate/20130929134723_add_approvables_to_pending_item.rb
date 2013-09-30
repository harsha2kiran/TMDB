class AddApprovablesToPendingItem < ActiveRecord::Migration
  def change
    add_column :pending_items, :approvable_id, :integer
    add_column :pending_items, :approvable_type, :string
  end
end
