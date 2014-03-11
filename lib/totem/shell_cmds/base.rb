module Totem
  module ShellCmds
    class Base
      def initialize(args)
        @args = args
      end

      def run
        raise 'You must implement this method in a subclass.'
      end
    end
  end
end
