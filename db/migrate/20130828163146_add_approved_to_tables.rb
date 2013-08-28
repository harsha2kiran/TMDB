class AddApprovedToTables < ActiveRecord::Migration
  def change
    add_column :keywords, :approved, :boolean
    add_column :languages, :approved, :boolean
    add_column :social_apps, :approved, :boolean
  end
end
