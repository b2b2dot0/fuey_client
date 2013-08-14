require "active_model"
require "active_support"

module Fuey
  class Trace
    include ActiveModel::Model

    attr_accessor :name, :steps

    def initialize(args)
      super(args)
      @steps ||= Array.new
    end

    def self.all
      Config.traces.keys.map do |trace_name|
        trace = Trace.new :name => trace_name
        Config.traces.send(trace_name).each do |step|
          inspection = ActiveSupport::Inflector.constantize %(Fuey::Inspections::#{step.keys.first})
          trace.steps.push inspection.new(step.values.first)
        end
        trace
      end
    end

    def to_s
      %(#{name}: [#{steps.join(', ')}])
    end

    def run
      ActiveSupport::Notifications.instrument("run.trace", {:trace => self.to_s}) do
        run, failed, current = 0, 0, ""
        steps.each do |step|
          run += 1
          current = step.name
          if step.execute
          else
            failed += 1
            break
          end
        end
        if failed == 0
          %(#{name} passed. #{steps.size} steps, #{run} executed, #{failed} failed.)
        else
          %(#{name} failed on #{current}. #{steps.size} steps, #{run} executed, #{failed} failed.)
        end
      end
    end
  end
end
