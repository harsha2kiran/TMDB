class AddSeoToMovieAndPerson < ActiveRecord::Migration
  def change

    add_column :movies, :meta_title, :string
    add_column :movies, :meta_description, :string
    add_column :movies, :meta_keywords, :string

    add_column :people, :meta_title, :string
    add_column :people, :meta_description, :string
    add_column :people, :meta_keywords, :string

  end
end
