class Api::V1::TagsController < Api::V1::BaseController

  inherit_resources

  def show
    @tag = Tag.find params[:id]
  end

end
