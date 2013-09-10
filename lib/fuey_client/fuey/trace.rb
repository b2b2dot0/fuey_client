require "fuey_client/fuey/model_initializer"
require "fuey_client/fuey/reporters"
require "active_support"
require "observer"

module Fuey
  class Trace
    include ModelInitializer
    include Observable

    attr_accessor :name

    def initialize(args)
      super(args)
    end

    def receiver=(observer)
      add_observer observer
    end

    def add_step(inspection)
      inspection.add_observer(self)
      inspection.add_observer(error_logger)
      steps.push inspection
      inspection
    end

    def steps
      @_steps ||= Array.new
    end

    def error_logger
      @_error_logger ||= Fuey::Reporters::ErrorLogger.new
    end
    private :error_logger

    def to_s
      %(#{name}: [#{steps.join(', ')}])
    end

    # Handle updates from inpsections via observation
    def update(status)
      changed
      notify_observers :update, name, [status]
      true
    end

    def status
      @_current ? @_current.state : "pending"
    end

    def status_message
      @_current.failed? ? @_current.status_message : ""
    end

    def run
      changed
      notify_observers :new, name, steps.map(&:status)

      ActiveSupport::Notifications.instrument("run.trace", {:trace => self.to_s}) do
        run, failed, @_current = 0, 0, nil
        steps.each do |step|
          run += 1
          @_current = step
          step.execute
          if step.failed?
            failed += 1
            break
          end
        end

        changed
        notify_observers :complete, self
        if failed == 0
          %(#{name} passed. #{steps.size} steps, #{run} executed, #{failed} failed.)
        else
          %(#{name} failed on #{@_current.name}. #{steps.size} steps, #{run} executed, #{failed} failed.)
        end
      end
    end
  end
end
