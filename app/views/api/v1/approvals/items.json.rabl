object @items
case @type
  when "Image"
    attributes :id, :approved, :image_file, :image_type, :is_main_image, :imageable_id, :imageable_type, :title, :user_id, :priority, :temp_user_id, :created_at, :updated_at
  when "Video"
    attributes :id, :approved, :link, :link_active, :priority, :quality, :videable_id, :videable_type, :video_type, :user_id, :title, :description, :category, :comments, :duration, :thumbnail, :temp_user_id, :created_at, :updated_at
  when "AlternativeName"
    attributes :id, :alternative_name, :approved, :person_id, :user_id, :temp_user_id, :created_at, :updated_at
  when "AlternativeTitle"
    attributes :id, :alternative_title, :approved, :language_id, :movie_id, :user_id, :temp_user_id, :created_at, :updated_at
  when "Cast"
    attributes :id, :approved, :character, :movie_id, :person_id, :user_id, :temp_user_id, :created_at, :updated_at
  when "Company"
    attributes :id, :approved, :company, :created_at, :updated_at
  when "Crew"
    attributes :id, :approved, :job, :movie_id, :person_id, :user_id, :temp_user_id, :created_at, :updated_at
  when "Genre"
    attributes :id, :genre, :approved, :created_at, :updated_at
  when "Keyword"
    attributes :id, :keyword, :approved, :created_at, :updated_at
  when "Language"
    attributes :id, :language, :approved, :created_at, :updated_at
  when "MovieGenre"
    attributes :id, :approved, :genre_id, :movie_id, :user_id, :temp_user_id, :created_at, :updated_at
  when "MovieKeyword"
    attributes :id, :approved, :keyword_id, :movie_id, :user_id, :temp_user_id, :created_at, :updated_at
  when "MovieLanguage"
    attributes :id, :approved, :language_id, :movie_id, :user_id, :temp_user_id, :created_at, :updated_at
  when "MovieMetadata"
    attributes :id, :approved, :budget, :homepage, :imdb_id, :movie_id, :movie_type_id, :runtime, :status_id, :user_id, :temp_user_id, :created_at, :updated_at
  when "PersonSocialApp"
    attributes :id, :approved, :person_id, :profile_link, :social_app_id, :user_id, :temp_user_id, :created_at, :updated_at
  when "ProductionCompany"
    attributes :id, :approved, :company_id, :movie_id, :user_id, :temp_user_id, :created_at, :updated_at
  when "Release"
    attributes :id, :approved, :certification, :confirmed, :country_id, :movie_id, :primary, :release_date, :user_id, :temp_user_id, :created_at, :updated_at
  when "RevenueCountry"
    attributes :id, :approved, :country_id, :movie_id, :revenue, :user_id, :temp_user_id, :created_at, :updated_at
  when "SocialApp"
    attributes :id, :link, :social_app, :approved, :created_at, :updated_at
  when "Tag"
    attributes :id, :approved, :person_id, :taggable_id, :taggable_type, :user_id, :temp_user_id, :created_at, :updated_at
end

