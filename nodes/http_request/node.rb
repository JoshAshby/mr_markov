FlowGraph::Nodes.register 'http request' do
  on :start_up do |options|
    binding.pry
  end

  on :receive do |message|
  end

  on :shut_down do
  end
end
