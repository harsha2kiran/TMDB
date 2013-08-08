class Api::V1::MoviesController < Api::V1::BaseController

  inherit_resources

  def create
    logger.info params.to_yaml
    render nothing: true
  end
end
