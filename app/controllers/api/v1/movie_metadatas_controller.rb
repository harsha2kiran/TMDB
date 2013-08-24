class Api::V1::MovieMetadatasController < Api::V1::BaseController

  inherit_resources

  # def create
  #   raise @movie_metadata.to_yaml
  #   create! do |format|
  #     # @old_metadata = MovieMetadata.where(movie_id: @movie_metadata.movie_id)
  #     # @old_metadata.each do |m|
  #     #   m.approved = false
  #     #   m.save
  #     # end
  #     # format.json { render json:  @movie_metadata }
  #   end
  # end

end
