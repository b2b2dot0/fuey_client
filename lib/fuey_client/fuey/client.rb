require "fuey_client/fuey/config"
require "fuey_client/fuey/log"
require "fuey_client/fuey/null_object"
require "fuey_client/fuey/trace"
require "fuey_client/fuey/inspections"
require "fuey_client/fuey/reporters"
require "fuey_client/fuey/trace_repository"

require "active_support"

module Fuey
  class Client
    def initialize(path_to_config_dir="", notifications=nil)
      Configurethis.root_path = path_to_config_dir

      notifications = Config::Fuey.notifications if notifications.nil?
      setup_notifications notifications
    end

    def reporter
      @_reporter ||= Reporters::NotificationQueue.new(Fuey::Redis.instance)
    end

    def run
      TraceRepository.new.all.each do |trace|
        trace.receiver = reporter
        output = trace.run
        Log.write %([#{trace.name}] #{output})
      end
    end

    def setup_notifications(notifications)
      notifications.each do |name, subscriber|
        ActiveSupport::Notifications.subscribe name, ActiveSupport::Inflector.constantize(subscriber).new
      end
    end
  end
end
