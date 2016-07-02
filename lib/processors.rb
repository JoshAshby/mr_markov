# Container for basic processor related functionality, along with acting as a
# registry of all processors.
class Processors
  class << self
    # @!attribute [rw] registry
    #   @return [Hash<#to_sym, Processors::Base>] Underlying storage of the registry
    def registry
      @@registery ||= {}
    end

    # @param [#to_sym] name Name to register the processor under
    # @param [Processors::Base] as Class to register as the processor
    # @raise [ArgumentError] If +as+ if not of type Processors::Base
    def register name, as:
      unless as.class == Class && as.ancestors.include?(Processors::Base)
        fail ArgumentError, "Need to register a Processor that inherits from Processors::Base!"
      end

      registry[ name.to_sym ] = as
    end

    def unregister name
      registry.delete name.to_sym
    end

    def get name
      registry[name.to_sym]
    end
  end
end
