class ChangeDatatypeForPriority < ActiveRecord::Migration
  def up
    change_table :videos do |t|
      t.change :priority, :decimal, :precision => 8, :scale => 2
    end

    change_table :movies do |t|
      t.change :popular, :decimal, :precision => 8, :scale => 2
    end
  end

  def down
  end
end
