class AddPriorityToImage < ActiveRecord::Migration
  def change
    add_column :images, :priority, :decimal, :precision => 8, :scale => 2
  end
end
