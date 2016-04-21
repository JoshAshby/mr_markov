require 'logger'

FileUtils.mkdir_p AshFrame.root.join('logs')

class MrMarkov
  def self.logger
    @logger ||= Logger.new(AshFrame.root.join('logs', 'mr_markov.log').open('a')).tap do |logger|
      # setup our logger for everything...
      logger.level = Logger::DEBUG if AshFrame.environment == :development
      logger.extend ActiveSupport::Logger.broadcast(Logger.new(STDOUT)) if AshFrame.environment != :test
    end
  end
end
