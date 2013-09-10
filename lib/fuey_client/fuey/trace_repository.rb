require "fuey_client/fuey/trace"

module Fuey
  class TraceRepository
    def all
      traces ||= Config::Fuey.traces.keys.map do |trace_name|
        fetch trace_name
      end
    end

    def fetch(trace_name)
      trace = Trace.new :name => trace_name
      Config::Fuey.traces.send(trace_name).each do |step|
        inspection_class = ActiveSupport::Inflector.constantize %(Fuey::Inspections::#{step.keys.first})
        inspection = inspection_class.new(step.values.first)
        trace.add_step inspection
      end
      trace
    end
  end
end
