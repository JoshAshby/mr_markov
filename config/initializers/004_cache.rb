class MrMarko
  def self.cache
    @cache ||= ActiveSupport::Cache::FileStore.new AshFrame.root.join('cache/'), compress: true
  end
end
