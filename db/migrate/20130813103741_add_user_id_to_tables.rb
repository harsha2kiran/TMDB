class AddUserIdToTables < ActiveRecord::Migration
  def change
    add_column :alternative_names, :user_id, :integer
    add_column :alternative_titles, :user_id, :integer
    add_column :casts, :user_id, :integer
    add_column :crews, :user_id, :integer
    add_column :images, :user_id, :integer
    add_column :movies, :user_id, :integer
    add_column :movie_genres, :user_id, :integer
    add_column :movie_keywords, :user_id, :integer
    add_column :movie_languages, :user_id, :integer
    add_column :movie_metadata, :user_id, :integer
    add_column :people, :user_id, :integer
    add_column :person_social_apps, :user_id, :integer
    add_column :production_companies, :user_id, :integer
    add_column :releases, :user_id, :integer
    add_column :revenue_countries, :user_id, :integer
    add_column :tags, :user_id, :integer
    add_column :views, :user_id, :integer
  end
end
