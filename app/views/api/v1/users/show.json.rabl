object @user
if params[:moderate] && params[:moderate] == "true"
  attributes :id, :email, :biography, :confirmed_at, :first_name, :image_file, :last_name, :points, :user_type, :created_at, :updated_at, :active
else
  attributes :id, :email, :biography, :confirmed_at, :first_name, :image_file, :last_name, :points, :user_type, :created_at, :updated_at
end
node(:badges) { |user| user.badges }
