require "fuey_client/fuey/inspections/support/shell_command"

module Fuey
  module Inspections
    class SNMPWalk < Fuey::Inspections::Inspection
      attr_accessor :ip, :agent, :oid, :version, :community, :response

      def initialize(args)
        super(args)
        @version ||= "v1"
        @community ||= "public"
        @status_message = ""
      end

      def _execute
        @response = Support::ShellCommand.new(snmp_walk_command).execute
        result = (response =~ /#{ip}/)
        if result
          self.pass
        else
          self.fail
        end
      end

      def status_message
        return %(SNMPWalk #{state} #{snmp_walk_command}) if @response.nil? || passed?
        %(SNMPWalk #{state}. #{response})
      end

      def settings
        snmp_walk_command || ""
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
