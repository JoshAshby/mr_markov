class Processors
  module OptionsMetaDSL
    extend ActiveSupport::Concern

    class_methods do
      def meta_options *required, **optional, &block
        metas = DSL.call(*required, **optional, &block)
        metas.each do |key, meta|
          options[key].meta = meta
        end
      end
    end

    private

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
