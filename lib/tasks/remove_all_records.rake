namespace :records do
  desc "Add admin users"
  task :remove_all => :environment do
    ["AlternativeName", "AlternativeTitle", "Cast", "Company", "Crew", "Genre", "Image", "Keyword", "Language", "Movie", "MovieGenre", "MovieKeyword", "MovieLanguage", "MovieMetadata", "Person", "PersonSocialApp", "ProductionCompany", "Release", "RevenueCountry", "SocialApp", "Tag", "UserBadge", "Video", "List", "ListItem", "Status"].each do |model|
      model.constantize.destroy_all
    end
  end
end
