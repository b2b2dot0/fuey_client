require "net/ping"
require "active_model"

module Fuey
  module Inspections
    class Ping
      include ActiveModel::Model

      attr_accessor :host, :name

      def execute
        result = Net::Ping::External.new(@host).ping
        Log.write "[#{@name}] Pinging #{@host} #{result ? 'succeeded' : 'failed'}."
        result
      end

      def to_s
        %(Ping #{name} #{host})
      end
    end
  end
end
