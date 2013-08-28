object @image
attributes :id, :approved, :image_file, :image_type, :is_main_image, :imageable_id, :imageable_type, :title, :priority, :created_at, :updated_at
node(:videos) { |image| image.videos }
node(:tags) { |image|
  partial("api/v1/tags/index", :object => image.tags.select {|s| s.approved == true } )
}
node(:follows) { |image| image.follows }
node(:views) { |image| image.views.count }
