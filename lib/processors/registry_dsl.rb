class Processors
  module RegistryDSL
    extend ActiveSupport::Concern

    class_methods do
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
    end
  end
end
