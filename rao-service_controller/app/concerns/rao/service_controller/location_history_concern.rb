module Rao
  module ServiceController::LocationHistoryConcern
    extend ActiveSupport::Concern

    included do
      if respond_to?(:before_action)
        before_action :store_location
      else
        before_filter :store_location
      end
    end

    private

    def store_location
      truncate_location_history(9)
      location_history[Time.zone.now] = request.referer
    end

    def location_history
      session[:location_history] ||= {}
    end

    def last_location
      location_history.sort.last.try(:last)
    end

    def truncate_location_history(count = 0)
      return if location_history.size <= count
      session[:location_history] = session[:location_history].sort.last(count).to_h
    end
  end
end