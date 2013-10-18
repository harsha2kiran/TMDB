class Api::V1::CacheController < ApplicationController

  def expire
    key = params[:key]
    type = params[:type]
    begin
      if type == "key"
        logger.info "delete key " + key
        @cache.delete key
      else
        logger.info "flush all cache"
        @cache.flush
      end
    rescue
    end
    status = "Cache item already deleted"
    render json: { status: status }
  end

end
