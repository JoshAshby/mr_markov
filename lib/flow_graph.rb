class FlowGraph
  class << self
    def injest_config config
      binding.pry
    end

    attr_accessor :logger

    def logger
      @_logger ||= Logger.new
    end

    def read_dir dir
      root = Pathname.new dir

      dir.reject{ |i| i =~ /^\./ }.each do |name|
        file = root.join name
        contents = file.read

        if file.extname =~ /\.rb.*/
          eval contents
        end
      end
    end
  end

  class Nodes
    class << self
      # @!attribute [rw] registry
      #   @return [Hash<#to_s, FlowGraph::Node>] Underlying storage of the registry
      def registry
        @@_registry ||= {}
      end

      def register node_type, &block
        registry[ node_type ] = NodesDSL.new.cloak(&block).events
      end
    end
  end

  class NodesDSL
    def on event_key, &block
      events[ event_key.to_sym ] ||= []
      events[ event_key.to_sym ] << block

      nil
    end

    def events
      @events ||= {}
    end

    # Stolen from https://github.com/robacarp/andrew/blob/6c297d3a98d39ff7a4060efa9a4a1c24b70b3153/lib/andrew/web/proxy.rb#L67
    # Which is in turn adapted from: http://www.skorks.com/2013/03/a-closure-is-not-always-a-closure-in-ruby/
    def cloak *args, closure: nil, &b
      executor = self.class.class_eval do
        define_method :dsl_executor, &b
        meth = instance_method :dsl_executor
        remove_method :dsl_executor
        meth
      end

      closure ||= b.binding

      with_closure_from closure do
        executor.bind(self).call(*args)
      end
    end

    private

    def with_closure_from binding, &block
      @_parent_binding = binding
      result = block.call
      @_parent_binding = nil
      result
    end

    def method_missing method, *args, &block
      if @_parent_binding
        @_parent_binding.send method, *args, &block
      end
    end
  end

  # class NodeRegistry
  #   class << self
  #     # @!attribute [rw] registry
  #     #   @return [Hash<#to_sym, FlowGraph::Node>] Underlying storage of the registry
  #     def registry
  #       @@_registry ||= {}
  #     end

  #     # @param [#to_sym] as_type Name to register the node under
  #     # @param [FlowGraph::Node] node Class to register as the node
  #     # @raise [ArgumentError] If +node+ if not of type FlowGraph::Node
  #     def register_node node, as_type:
  #       unless node.class == Class && node.ancestors.include?(FlowGraph::Node)
  #         fail ArgumentError, "Need to register a Node that inherits from FlowGraph::Node!"
  #       end

  #       registry[ as_type.to_sym ] = node
  #     end

  #     def unregister_node name
  #       registry.delete name.to_sym
  #     end

  #     def get_node name
  #       registry[ name.to_sym ]
  #     end
  #   end
  # end
end
