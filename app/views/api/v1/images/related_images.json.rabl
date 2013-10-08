object @related_images
attributes :id, :approved, :image_file, :image_type, :is_main_image, :imageable_id, :imageable_type, :title, :priority, :created_at, :updated_at, :description
node(:belongs_to) { |image| image.list_items.map(&:list_id) }
