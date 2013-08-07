object @videos
attributes :id, :approved, :link, :link_active, :priority, :quality, :videable_id, :videable_type, :video_type, :created_at, :updated_at
node(:tags) { |video| video.tags }
node(:images) { |video| video.images }
node(:follows) { |video| video.follows }
node(:views) { |video| video.views }
