class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.text :biography
      t.string :email
      t.string :password
      t.string :user_type
      t.string :image_file
      t.datetime :confirmed_at
      t.integer :points

      t.timestamps
    end
  end
end
