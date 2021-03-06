module RocketJobMissionControl
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    around_action :with_time_zone

    private

    def with_time_zone
      if time_zone = session['time_zone'] || 'UTC'
        Time.use_zone(time_zone) { yield }
      end
    end
  end
end
