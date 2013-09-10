require "fuey_client/fuey/model_initializer"

module Fuey
  module Inspections
    module Support
      class Status
        include ModelInitializer
        include Comparable

        attr_accessor :type, :name, :status, :settings, :status_message

        def passed?
          status == 'passed'
        end

        def failed?
          status == 'failed'
        end

        def attributes
          [:type, :name, :status, :settings, :status_message].inject(Hash.new) do |memo, attr|
            memo[attr] = self.send(attr)
            memo
          end
        end

        def <=>(another)
          attributes.hash <=> another.attributes.hash
        end
      end
    end
  end
end
