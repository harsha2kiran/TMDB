object @images
attributes :id, :approved, :image_file, :image_type, :is_main_image, :imageable_id, :imageable_type, :title, :priority, :created_at, :updated_at, :description
node(:tags) { |image| image.tags }
# node(:videos) { |image| image.videos }
node(:follows) { |image| image.follows }
node(:views) { |image| image.views }
