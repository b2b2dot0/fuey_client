require "json"
require "fuey_client/fuey/redis"

module Fuey
  module Reporters
    class NotificationQueue
      def initialize(redis)
        @_redis = redis
      end

      def update(type, *args)
        self.send("publish_#{type}", args)
        true
      end

      def publish_update(args)
        trace_name, statuses = args[0], args[1]
        status = statuses.first
        message = [ trace_name, status.attributes ]
        @_redis.publish "fuey.trace.update", message.to_json
      end

      def publish_complete(args)
        trace = args.first
        message = {
          :time => Time.now.strftime("%Y%m%d%H%M%S"),
          :name => trace.name,
          :status => trace.status,
          :status_message => trace.status_message,
          :steps => trace.steps.map(&:status).map(&:attributes)
        }
        @_redis.lpush trace.name.downcase, message.to_json
      end

      def publish_new(args)
        trace_name, statuses = args[0], args[1]
        message = {
          :name => trace_name,
          :status => "executed",
          :status_message => "",
          :steps => statuses.map(&:attributes)
        }
        @_redis.publish "fuey.trace.new", message.to_json
      end
    end
  end
end
