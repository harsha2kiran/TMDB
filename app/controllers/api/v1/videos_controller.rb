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
    @video = Video.where(approved: true).find_all_by_id(params[:id])
    if @video != []
      @video = @video.first
      # @movies = Movie.find_all_by_id @video.tags.map(&:taggable_id)
      # @people = Person.find_all_by_id @video.tags.map(&:person_id)
    end
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
      thumbnail = response.thumbnails[1] ? response.thumbnails[1].url : ""
      thumbnail2 = response.thumbnails[0] ? response.thumbnails[0].url : ""
      thumbnail3 = response.thumbnails[2] ? response.thumbnails[2].url : ""
      title = response.title
      description = response.description
      duration = response.media_content.first.duration
      comments = response.access_control["comment"]
      category = response.categories.first.label
    end
    render json: { title: title, description: description, duration: duration, comments: comments, category: category, thumbnail: thumbnail, thumbnail2: thumbnail2, thumbnail3: thumbnail3 }
  end

  def fetch_username
    username = params[:username]
    if username
      client = YouTubeIt::Client.new
      videos = client.get_all_videos(user: username)
    end
    render json: { videos: videos }
  end

  def fetch_search
    search = params[:search]
    if search
      client = YouTubeIt::Client.new
      videos = client.videos_by(query: search)
    end
    render json: { videos: videos }
  end

  def fetch_playlist
    playlist = params[:playlist]
    if playlist
      client = YouTubeIt::Client.new
      videos = client.playlist(playlist)
      videos = videos.videos
    end
    render json: { videos: videos }
  end

  def import_all
    videos = params[:videos]
    success_links = []
    videos.each do |video|
      new_video = Video.new(video[1])
      new_video.videable_id = params[:videable_id]
      new_video.videable_type = params[:videable_type]
      if new_video.save!
        success_links << new_video.link
        if params[:videable_type] == "List"
          list_item = ListItem.new
          list_item.listable_id = new_video.id
          list_item.listable_type = "Video"
          list_item.user_id = current_api_user.id if current_api_user
          list_item.temp_user_id = params[:temp_user_id]
          list_item.list_id = params[:list_id]
          list_item.save!
        end
      end
    end
    render json: { success_links: success_links }
  end

end
