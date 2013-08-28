class Api::V1::VideosController < Api::V1::BaseController

  inherit_resources

  def index
    @videos = Video.where(approved: true).includes(:taggable)
    movie_ids = []
    @videos.each do |video|
      movie_ids << video.map(&:taggable_id)
    end
    movie_ids = movie_ids.flatten
    @movies = Movie.find_all_by_id movie_ids
    @people = Person.find_all_by_id @videos.tags.map(&:person_id)
  end

  def show
    @video = Video.where(approved: true).find(params[:id])
    @movies = Movie.find_all_by_id @video.tags.map(&:taggable_id)
    @people = Person.find_all_by_id @video.tags.map(&:person_id)
  end

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
