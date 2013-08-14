require "fuey_client/fuey/inspections/support/shell_command"
require "active_model"

module Fuey
  module Inspections
    class SNMPWalk
      include ActiveModel::Model

      attr_accessor :name, :ip, :agent, :oid, :version, :community

      def initialize(args)
        super(args)
        @version ||= "v1"
        @community ||= "public"
      end

      def execute
        result = Support::ShellCommand.new(snmp_walk_command).execute
        result = result =~ /#{@ip}/
        Log.write %([#{@name}] SNMPWalk for #{@ip} using #{@agent} #{result ? "succeeded" : "failed" }.)
        result
      end

      def to_s
        snmp_walk_command
      end

      def snmp_walk_command
        %(snmpwalk -#{@version} -c #{@community} #{@agent} #{@oid})
      end
      private :snmp_walk_command

    end
  end
end
