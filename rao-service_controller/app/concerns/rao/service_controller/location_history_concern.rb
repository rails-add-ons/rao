module Rao
  module ServiceController::LocationHistoryConcern
    extend ActiveSupport::Concern

    included do
      if respond_to?(:before_action)
        before_action :store_location
      else
        before_filter :store_location
      end

      helper_method :last_location
    end

    private

    def store_location
      return if request.referer.nil?
      truncate_location_history(3)
      puts "[LocationHistoryConcern] Storing last location [#{request.referer}]"
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
      truncated = session[:location_history].sort.last(count)
      session[:location_history] = if truncated.respond_to?(:to_h)
        truncated.to_h
      else
        truncated.each_with_object({}) { |a, hash| hash[a.first] = a.last }
      end
    end
  end
end