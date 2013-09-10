require "observer"
require "stately"
require "fuey_client/fuey/model_initializer"
require "fuey_client/fuey/inspections/support/status"

module Fuey
  module Inspections
    class Inspection
      include ModelInitializer
      include Observable

      attr_accessor :name, :state

      stately :start => :pending, :attr => :state do
        state :executed, :action => :execute  do
          before_transition :do => :notify
          after_transition  :do => :notify
          after_transition  :do => :_execute
        end
        state :passed, :action => :pass do
          after_transition  :do => :notify
        end
        state :failed, :action => :fail do
          after_transition  :do => :notify
        end
      end

      def status
        Support::Status.new(
                            :type => self.class.to_s.split('::').last,
                            :name => name,
                            :status => state,
                            :settings => settings, # defined in child class
                            :status_message => status_message # defined in child class
                            )
      end

      def settings; end
      def status_message; end

      def passed?
        state == 'passed'
      end

      def failed?
        state == 'failed'
      end

      def notify
        changed
        notify_observers status
      end

    end
  end
end
