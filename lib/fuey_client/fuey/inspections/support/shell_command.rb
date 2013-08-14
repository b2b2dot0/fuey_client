module Fuey
  module Inspections
    module Support
      class ShellCommand
        def initialize(command)
          @command = command
        end

        def execute
          %x(#{@command})
        end
      end
    end
  end
end
