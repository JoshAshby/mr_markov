require 'redis'
# require 'redis-namespace'

# require 'sidekiq'
# require 'connection_pool'

# require 'redlock'

class MrMarkov
  def self._redis_conn(**opts)
    # Redis::Namespace.new :mrmarkov, { redis: Redis.new(**AshFrame.config_for(:redis).symbolize_keys, driver: :hiredis) }.merge(opts)
    Redis.new(**AshFrame.config_for(:redis).symbolize_keys.merge(opts), driver: :hiredis)
  end

  # def self.redis_pool
  #   @redis_pool ||= ConnectionPool.new(size: 5, timeout: 5) { _redis_conn }
  # end

  # def lock_manager
  #   @lock_manager ||= Redlock::Client.new [ MrMarkov._redis_conn ]
  # end
end

Redis.current = MrMarkov._redis_conn

# Sidekiq.configure_server do |config|
#   config.redis = ConnectionPool.new(size: 15) { MrMarkov._redis_conn }
# end

# Sidekiq.configure_client do |config|
#   config.redis = ConnectionPool.new(size: 15) { MrMarkov._redis_conn }
# end
