class Util
  class << self
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

class FlowGraph
  class << self
    def build config
      nodes = {}
      edges = {}

      nodes = config['nodes'].each_with_object({}) do |node_config, memo|
        unbound_block = Nodes.registry[ node_config['type'] ]

        node = Node.new node_config['id'], node_config['name']
        node.instance_exec node_config['properties'], &unbound_block

        memo[ node_config['id'] ] = node
      end

      edges = config.fetch('edges', []).each_with_object({}) do |edge_config, memo|
        memo[ edge_config['from_node_id'] ] ||= []
        memo[ edge_config['from_node_id'] ] << edge_config['to_node_id']
      end

      graph = {
        id: config['id'],
        name: config['name'],
        nodes: nodes,
        edges: edges
      }

      binding.pry
    end
  end

  class Node
    def initialize id, name
      @id   = id
      @name = name
    end

    def on event_key, &block
      events[ event_key.to_sym ] ||= []
      events[ event_key.to_sym ] << block

      nil
    end

    def emit event_key, *payload
      events[ event_key.to_sym ].map{ |e| e.call(*payload) }
    end

    def events
      @events ||= {}
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
        registry[ node_type ] = block
      end
    end
  end
end
