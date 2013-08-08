class Api::V1::BaseController < ApplicationController

  respond_to :json
  before_filter :authenticate_user!

end
