class Api::V1::ImagesController < Api::V1::BaseController

  inherit_resources

  def index
    @images = Image.where(approved: true)
  end

  def show
    @image = Image.where(approved: true).find(params[:id])
  end
end
