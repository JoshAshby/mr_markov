require 'redis'

class MrMarkov
  def self._redis_conn(**opts)
    Redis.new(**AshFrame.config_for(:redis).symbolize_keys.merge(opts), driver: :hiredis)
  end
end

Redis.current = MrMarkov._redis_conn
