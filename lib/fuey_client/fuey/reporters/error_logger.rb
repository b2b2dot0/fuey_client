require "fuey_client/fuey/log"

module Fuey
  module Reporters
    class ErrorLogger
      def update(status)
        if status.failed?
          Log.alert "#{status.name} failed. #{status.status_message}"
        end
      end
    end
  end
end
