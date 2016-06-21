class MrMarkov
  def self.cache
    @cache ||= ActiveSupport::Cache.lookup_store :redis_store, **AshFrame.config_for(:redis).symbolize_keys.merge({ driver: :hiredis })
  end
end
