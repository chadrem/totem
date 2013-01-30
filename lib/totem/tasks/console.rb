module Totem
  module Tasks
    class Console
      def start
        ARGV.clear
        IRB.start
      end
    end
  end
end
