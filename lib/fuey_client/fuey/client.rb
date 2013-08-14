require "fuey_client/fuey/log"
require "fuey_client/fuey/config"
require "fuey_client/fuey/trace"
require "fuey_client/fuey/inspections"
require "net/ping"
require "active_support"

module Fuey
  class Client
    def initialize(path_to_config_dir="", notifications=nil)
      Configurethis.root_path = path_to_config_dir

      notifications = Config.notifications if notifications.nil?
      setup_notifications notifications
    end

    def run
      Trace.all.each do |trace|
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
