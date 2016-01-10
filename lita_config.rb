Lita.configure do |config|
  config.robot.name = "MrMarkov"
  config.robot.locale = :en
  config.robot.log_level = :debug

  config.redis[:url] = ENV["REDIS_URL"]
  config.http.port = ENV["PORT"] || 8080

  config.robot.adapter = :irc

  config.robot.admins = [ "73300d4f-d6e5-45e6-8f94-22c283ed166d" ]

  config.adapters.irc.server = "irc.freenode.net"
  config.adapters.irc.channels = [ "#mr_markov" ]
  config.adapters.irc.realname = "Salsasaurus"
end
