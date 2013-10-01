class AddTempUserAndUserToListItem < ActiveRecord::Migration
  def change
    add_column :list_items, :user_id, :integer
    add_column :list_items, :temp_user_id, :string
  end
end
