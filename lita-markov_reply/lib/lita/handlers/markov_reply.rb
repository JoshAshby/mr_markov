module Lita
  module Handlers
    class MarkovReply
      extend Handler::ChatRouter
      extend Handler::HTTPRouter

      Lita.register_handler self

      route(/^say, MrMarkov,\s+(.+)/, :chat_say)

      def chat_say robot
        robot.reply robot.matches.to_s
      end

      http.get '/', :http_root

      def http_root request, response
        response.headers["Content-Type"] = "application/json"

        json = MultiJson.dump(
          lita_version: Lita::VERSION,
          robot_name: robot.name,
          robacarp: "HI ROB!!!!"
        )

        response.write json
      end
    end
  end
end
