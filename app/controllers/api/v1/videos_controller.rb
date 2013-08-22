class Api::V1::VideosController < Api::V1::BaseController

#   require 'nokogiri'
#   require 'open-uri'

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

end
