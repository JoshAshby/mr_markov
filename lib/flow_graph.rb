class FlowGraph
  class << self
    def injest_config config
      binding.pry
    end
  end

  class NodeRegistry
    class << self
      # @!attribute [rw] registry
      #   @return [Hash<#to_sym, FlowGraph::Node>] Underlying storage of the registry
      def registry
        @@_registry ||= {}
      end

      # @param [#to_sym] as_type Name to register the node under
      # @param [FlowGraph::Node] node Class to register as the node
      # @raise [ArgumentError] If +node+ if not of type FlowGraph::Node
      def register_node node, as_type:
        unless node.class == Class && node.ancestors.include?(FlowGraph::Node)
          fail ArgumentError, "Need to register a Node that inherits from FlowGraph::Node!"
        end

        registry[ as_type.to_sym ] = node
      end

      def unregister_node name
        registry.delete name.to_sym
      end

      def get_node name
        registry[ name.to_sym ]
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
  end
end
