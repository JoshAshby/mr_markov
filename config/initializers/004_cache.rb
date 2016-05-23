class MrMarkov
  def self.cache
    @cache ||= ActiveSupport::Cache.lookup_store :redis_store
  end
end
