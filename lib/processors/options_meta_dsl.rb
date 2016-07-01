class Processors
  module OptionsMetaDSL
    extend ActiveSupport::Concern

    class_methods do
      def meta
        @meta ||= {}
      end

      def meta_options *required, **optional, &block
        @meta = DSL.call(*required, **optional, &block)
      end
    end

    protected

    class DSL
      attr_reader :meta

      def self.call *required, **optional, &block
        inst = self.new
        inst.instance_exec(&block)
        inst.meta
      end

      def meta
        @meta ||= {}
      end

      def method_missing name, *args, **opts, &block
        meta[name] = opts

        self
      end

      def respond_to_missing? *args
        true
      end
    end
  end
end
