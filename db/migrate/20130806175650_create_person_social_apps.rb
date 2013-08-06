class CreatePersonSocialApps < ActiveRecord::Migration
  def change
    create_table :person_social_apps do |t|
      t.integer :person_id
      t.integer :social_app_id
      t.string :profile_link
      t.boolean :approved

      t.timestamps
    end
  end
end
