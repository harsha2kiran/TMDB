class CreateSocialApps < ActiveRecord::Migration
  def change
    create_table :social_apps do |t|
      t.string :social_app
      t.string :link

      t.timestamps
    end
  end
end
