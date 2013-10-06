class AddApprovalColumnsToKeywordAndTag < ActiveRecord::Migration
  def change
    add_column :list_keywords, :approved, :boolean
    add_column :list_tags, :approved, :boolean
    add_column :media_keywords, :approved, :boolean
    add_column :media_tags, :approved, :boolean
  end
end
