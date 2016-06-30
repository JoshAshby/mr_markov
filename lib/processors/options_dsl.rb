class Processors
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

    # TODO: Handle capturing metadata for things like type stating and such.
    # required could also be made a metadata entry too?
    def required *args, **opts
      args.each{ |arg| @options[arg] = Option.new true }
      opts.each{ |key, value| @options[key] = Option.new false, value }

      self
    end

    alias_method :optional, :required
  end
end
