# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130806181052) do

  create_table "alternative_names", :force => true do |t|
    t.integer  "person_id"
    t.string   "alternative_name"
    t.boolean  "approved"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "alternative_titles", :force => true do |t|
    t.integer  "movie_id"
    t.string   "alternative_title"
    t.integer  "language_id"
    t.boolean  "approved"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "badges", :force => true do |t|
    t.string   "badge"
    t.integer  "min_points"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "casts", :force => true do |t|
    t.integer  "movie_id"
    t.integer  "person_id"
    t.string   "character"
    t.boolean  "approved"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "companies", :force => true do |t|
    t.string   "company"
    t.boolean  "approved"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "countries", :force => true do |t|
    t.string   "country"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "crews", :force => true do |t|
    t.integer  "movie_id"
    t.integer  "person_id"
    t.string   "job"
    t.boolean  "approved"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "follows", :force => true do |t|
    t.integer  "user_id"
    t.integer  "followable_id"
    t.string   "followable_type"
    t.boolean  "approved"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "genres", :force => true do |t|
    t.string   "genre"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "images", :force => true do |t|
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.string   "title"
    t.string   "image_file"
    t.string   "image_type"
    t.boolean  "is_main_image"
    t.boolean  "approved"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "keywords", :force => true do |t|
    t.string   "keyword"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "languages", :force => true do |t|
    t.string   "language"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "list_items", :force => true do |t|
    t.integer  "list_id"
    t.integer  "listable_id"
    t.string   "listable_type"
    t.boolean  "approved"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "lists", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "movie_genres", :force => true do |t|
    t.integer  "movie_id"
    t.integer  "genre_id"
    t.boolean  "approved"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "movie_keywords", :force => true do |t|
    t.integer  "keyword_id"
    t.integer  "movie_id"
    t.boolean  "approved"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "movie_languages", :force => true do |t|
    t.integer  "movie_id"
    t.integer  "language_id"
    t.boolean  "approved"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "movie_metadata", :force => true do |t|
    t.integer  "movie_id"
    t.integer  "movie_type_id"
    t.integer  "budget"
    t.integer  "runtime"
    t.integer  "status_id"
    t.string   "imdb_id"
    t.string   "homepage"
    t.boolean  "approved"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "movies", :force => true do |t|
    t.string   "title"
    t.string   "tagline"
    t.text     "overview"
    t.integer  "content_score"
    t.boolean  "approved"
    t.hstore   "locked"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "people", :force => true do |t|
    t.string   "name"
    t.text     "biography"
    t.datetime "birthday"
    t.datetime "day_of_death"
    t.string   "place_of_birth"
    t.string   "homepage"
    t.string   "imdb_id"
    t.boolean  "approved"
    t.hstore   "locked"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "person_social_apps", :force => true do |t|
    t.integer  "person_id"
    t.integer  "social_app_id"
    t.string   "profile_link"
    t.boolean  "approved"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "production_companies", :force => true do |t|
    t.integer  "movie_id"
    t.integer  "company_id"
    t.boolean  "approved"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "releases", :force => true do |t|
    t.integer  "movie_id"
    t.boolean  "primary"
    t.integer  "country_id"
    t.datetime "release_date"
    t.string   "certification"
    t.boolean  "confirmed"
    t.boolean  "approved"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "reports", :force => true do |t|
    t.string   "reportable_type"
    t.integer  "reportable_id"
    t.integer  "user_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "revenue_countries", :force => true do |t|
    t.integer  "country_id"
    t.integer  "movie_id"
    t.integer  "revenue"
    t.boolean  "approved"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "social_apps", :force => true do |t|
    t.string   "social_app"
    t.string   "link"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "statuses", :force => true do |t|
    t.string   "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tags", :force => true do |t|
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "person_id"
    t.boolean  "approved"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "user_badges", :force => true do |t|
    t.integer  "user_id"
    t.integer  "badge_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.text     "biography"
    t.string   "email"
    t.string   "password"
    t.string   "user_type"
    t.string   "image_file"
    t.datetime "confirmed_at"
    t.integer  "points"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "videos", :force => true do |t|
    t.string   "link"
    t.integer  "videable_id"
    t.string   "videable_type"
    t.string   "video_type"
    t.string   "quality"
    t.boolean  "link_active"
    t.boolean  "approved"
    t.integer  "priority"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "views", :force => true do |t|
    t.string   "viewable_type"
    t.integer  "viewable_id"
    t.integer  "views_count"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

end
