class Processors
  module OptionsDSL
    extend ActiveSupport::Concern

    class_methods do
      def options
        @options ||= {}
      end

      def setup_options *required, **optional, &block
        @options = DSL.call(*required, **optional, &block)
      end
    end

    def options
      @options ||= {}
    end

    def setup_options! raw
      self.class.options.each do |name, settings|
        if  settings.required && ! raw.has_key?(name.to_s)
          fail ArgumentError, "Invalid options: #{ name } is required but missing"
        end

        value = raw[name.to_s] || settings.default

        options[name] = value
      end
    end

    protected

    class DSL
      Option = Struct.new :required, :default

      attr_reader :options

      def self.call *required, **optional, &block
        inst = DSL.new
        inst.required(*required, **optional).instance_exec(&block)
        inst.options
      end

      def options
        @options ||= {}
      end

      # TODO: Handle capturing metadata for things like type stating and such.
      # required could also be made a metadata entry too?
      def required *args, **opts
        args.each{ |arg| options[arg] = Option.new true }
        opts.each{ |key, value| options[key] = Option.new false, value }

        self
      end

      alias_method :optional, :required
    end
  end
end
