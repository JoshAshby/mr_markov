# Container for basic processor related functionality, along with acting as a
# registry of all processors by a nice easy to use name.
class Processors
  class << self
    def registry
      @@registery ||= {}
    end

    def register name, as:
      registry[ name ] = as
    end

    def unregister name
      registry.delete name
    end

    def get name
      name = name.to_sym
      registry[name]
    end
  end
end
