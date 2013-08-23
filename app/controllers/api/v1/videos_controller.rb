class Api::V1::VideosController < Api::V1::BaseController

  inherit_resources

  def validate_links
    @videos = Video.where(approved: true)
    @videos.each do |video|
      begin
        doc = Nokogiri::HTML(open(video.link))
        found = doc.css("#eow-title")
        if found && found.to_s != ""
          logger.info "Found: " + video.link
          video.link_active = true
          video.save
        else
          logger.info "Not found: " + video.link
          video.link_active = true
          video.save
        end
      rescue
        logger.info "Link not valid: " + video.link
        video.link_active = true
        video.save
      end
    end
    render json: { message: "Finished validating links." }
  end

  def check
    url = params[:link]
    client = YouTubeIt::Client.new
    response = client.video_by(url)
    if response
      if response.thumbnails.count > 1
        thumbnail = response.thumbnails[1].url
      else
        thumbnail = response.thumbnails.first.url
      end
      title = response.title
      description = response.description
      duration = response.media_content.first.duration
      comments = response.access_control["comment"]
      category = response.categories.first.label
    end
    render json: { title: title, description: description, duration: duration, comments: comments, category: category, thumbnail: thumbnail }
  end

end
