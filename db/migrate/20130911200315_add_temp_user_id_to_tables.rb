class AddTempUserIdToTables < ActiveRecord::Migration
  def change
    add_column :alternative_names, :temp_user_id, :string
    add_column :alternative_titles, :temp_user_id, :string
    add_column :casts, :temp_user_id, :string
    add_column :crews, :temp_user_id, :string
    add_column :images, :temp_user_id, :string
    add_column :lists, :temp_user_id, :string
    add_column :movies, :temp_user_id, :string
    add_column :movie_genres, :temp_user_id, :string
    add_column :movie_keywords, :temp_user_id, :string
    add_column :movie_languages, :temp_user_id, :string
    add_column :people, :temp_user_id, :string
    add_column :person_social_apps, :temp_user_id, :string
    add_column :production_companies, :temp_user_id, :string
    add_column :releases, :temp_user_id, :string
    add_column :reports, :temp_user_id, :string
    add_column :revenue_countries, :temp_user_id, :string
    add_column :tags, :temp_user_id, :string
    add_column :videos, :temp_user_id, :string
    add_column :views, :temp_user_id, :string
    add_column :movie_metadata, :temp_user_id, :string
  end
end
