require "fuey_client/fuey/log"
require "fuey_client/fuey/config"
require "fuey_client/fuey/inspections"
require "net/ping"

module Fuey
  class Client
    def initialize(path_to_config_dir="")
      Configurethis.root_path = path_to_config_dir
    end

    def run
      begin
        Config.inspections.pings.map{|name, host| Inspections::Ping.new(name, host) }.each do |ping|
          ping.execute
        end
      rescue => caught
        if (caught.message =~ /is not configured/)
          Log.write "Nothing configured."
        else
          raise caught
        end
      end

      begin
        Config.inspections.vpns.each do |vpn|
          Inspections::SNMPWalk.new(*vpn.values).execute
        end
      rescue => caught
      end
      0
    rescue => caught
      Log.write caught.message
      return 1
    end
  end
end
