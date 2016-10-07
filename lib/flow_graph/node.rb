class FlowGraph
  class Node
    class << self
      def register_as_type type
        FlowGraph::NodeRegistry.register_node self, as_type: type
      end
    end

    attr_reader :inputs, :options, :outputs

    def initialize inputs, options, outputs
      @inputs  = inputs
      @options = options
      @outputs = outputs
    end

    attr_accessor :logger, :context

    def logger
      @_logger ||= Logger.new
    end
  end
end
