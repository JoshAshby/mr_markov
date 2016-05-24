# Container for basic processor related functionality, along with acting as a
# registry of all processors by a nice easy to use name.
class Processors
  class << self
    def registery
      @@registery ||= []
    end

    def register name, as:
      registery << [ name, as ]
    end

    def get name
      name = name.to_sym
      registery.find{ |parts| parts[0] == name }[1]
    end
  end

  # Base setup for processors and the DSL definitions for a processors settings
  class Base
    class << self
      attr_reader :registered_as, :options

      def register_as name
        name = name.to_sym
        Processors.register name, as: self
        @registered_as = name
      end

      def setup_options *required, **optional, &block
        @options = OptionsDSL.call(*required, **optional, &block)
      end
    end

    attr_reader :logger, :options, :state, :cancel

    def initialize(options:, state: {}, logger: nil)
      @logger = logger || Logger.new(STDOUT) # TODO: Fix

      @state = state
      @options = {}

      self.class.options.each do |name, settings|
        if  settings.required && ! options.has_key?(name.to_s)
          fail "Invalid options: #{ name } is required but missing"
        end

        value = options[name.to_s] || settings.default

        @options[name] = value
      end
    end

    def cancel!(**opts)
      @cancel = true
      {}.merge(**opts)
    end
  end

  protected

  class OptionsDSL
    Option = Struct.new :required, :default

    attr_reader :options

    def self.call *required, **optional, &block
      inst = self.new
      inst.required(*required, **optional).instance_exec(&block)
      inst.options
    end

    def initialize
      @options = {}
    end

    def required *args, **opts
      args.each{ |arg| @options[arg] = Option.new true }
      opts.each{ |key, value| @options[key] = Option.new false, value }

      self
    end

    alias_method :optional, :required
  end
end
