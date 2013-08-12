object @person_social_apps
attributes :id, :approved, :person_id, :profile_link, :social_app_id, :created_at, :updated_at
node(:social_app){ |person_social_app|
  SocialApp.find person_social_app.social_app_id
}
