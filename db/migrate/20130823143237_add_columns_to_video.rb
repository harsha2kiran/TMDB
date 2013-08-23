class AddColumnsToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :description, :text
    add_column :videos, :comments, :string
    add_column :videos, :category, :string
    add_column :videos, :duration, :string
  end
end
