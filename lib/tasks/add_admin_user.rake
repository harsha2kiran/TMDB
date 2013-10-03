namespace :users do
  desc "Add admin users"
  task :add => :environment do
    path = Rails.root.join('lib', 'tasks', 'resources', 'user.yml')
    File.open(path) do |file|
      YAML.load_documents(file) do |doc|
        doc.keys.each do |key|
          attributes = doc[key]
          User.destroy_all
          user = User.new({:first_name => attributes['first_name'], :last_name => attributes['last_name'], :password => attributes['password'], :email => attributes['email'], confirmed_at: Time.now, user_type: attributes['user_type']})
          user.save!
        end
      end
    end
  end
end

