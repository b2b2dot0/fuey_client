require "redis"

module Fuey
  class Redis
    def self.instance
      @@redis ||= ::Redis.new(
                              :host => Config::Redis.host,
                              :port => Config::Redis.port )
    end
  end
end
