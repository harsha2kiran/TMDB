object @video
attributes :id, :approved, :link, :link_active, :priority, :quality, :videable_id, :videable_type, :video_type, :created_at, :updated_at, :title, :thumbnail, :description, :duration, :category, :duration
node(:tags) { |video|
  partial("api/v1/tags/index", :object => video.tags.select {|s| s.approved == true } )
}
node(:images) { |video| video.images }
node(:follows) { |video| video.follows }
node(:views) { |video| video.views.count }
