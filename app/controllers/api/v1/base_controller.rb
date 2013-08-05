class Api::V1::BaseController < ApplicationController

  # doorkeeper_for :all, :unless => lambda { user_signed_in? || params[:controller] == "api/v1/registrations" }

  respond_to :json

  # private

  # def current_resource_user
  #   if doorkeeper_token
  #     @current_resource_user ||= User.find(doorkeeper_token.resource_owner_id)
  #   else
  #     current_user
  #   end
  # end

end
