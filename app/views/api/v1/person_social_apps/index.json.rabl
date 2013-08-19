object @person_social_apps
attributes :id, :approved, :person_id, :profile_link, :social_app_id, :created_at, :updated_at
node(:social_app){ |person_social_app|
  SocialApp.find_by_id person_social_app.social_app_id
}
node(:person){ |crew|
  @people.select {|s| crew.person_id == s.id }[0]
}
