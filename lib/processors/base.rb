class Processors
  # Base setup for processors and the DSL definitions for a processors settings
  class Base
    class << self
      attr_reader :registered_as, :options

      def options
        @options ||= {}
      end

      def registered_as
        @registered_as ||= nil
      end

      def register_as name
        name = name.to_sym
        Processors.register name, as: self
        @registered_as = name
      end

      def unregister
        Processors.unregister @registered_as
        @registered_as = nil
      end

      def setup_options *required, **optional, &block
        @options = OptionsDSL.call(*required, **optional, &block)
      end
    end

    attr_reader :logger, :options, :state, :result

    def initialize(options:, state: {}, logger: nil)
      @logger    = logger || Logger.new(STDOUT)

      @state     = state
      @result    = {}
      @options   = {}

      self.class.options.each do |name, settings|
        if  settings.required && ! options.has_key?(name.to_s)
          fail ArgumentError, "Invalid options: #{ name } is required but missing"
        end

        value = options[name.to_s] || settings.default

        @options[name] = value
      end
    end

    def cancel! data={}, **opts
      @result = data.merge(opts)
      throw :halt, [ :cancel, @result ]
    end

    def propagate! data={}, **opts
      @result = data.merge(opts)
      throw :halt, [ :propagate, @result ]
    end

    def merge! data={}, **opts
      @result = data.merge(opts)
      throw :halt, [ :merge, @result ]
    end

    def pass_through!
      throw :halt, [ :pass_through, nil ]
    end
  end
end
