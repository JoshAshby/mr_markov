module Lita
  module Handlers
    class MarkovReply < Handler
      Lita.register_handler(self)

      route(/^say, MrMarkov,\s+(.+)/, :say)

      def say robot
        robot.reply robot.matches.to_s
      end
    end
  end
end
