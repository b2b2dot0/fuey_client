require "fuey_client/fuey/inspections/support/sap"

module Fuey
  module Inspections
    class RFCPing < Fuey::Inspections::Inspection
      attr_accessor :ashost, :sysnr, :client, :user, :passwd, :lang, :response

      def _execute
        result, @response = Support::SAP.new(config).ping
        if result
          self.pass
        else
          self.fail
        end
      end

      def to_s
        %(RFCPing #{ashost} with user #{user})
      end

      def status_message
        return %(RFCPing #{state} for #{ashost}. #{@response}) if failed?
        %(RFCPing #{state} for #{ashost}.)
      end

      def settings
        config.reject{|k,v| k == 'passwd'}
      end

      def config
        {
          'ashost' => ashost,
          'sysnr' => sysnr,
          'client' => client,
          'user' => user,
          'passwd' => passwd,
          'lang' => lang
        }
      end
      private :config
    end
  end
end
