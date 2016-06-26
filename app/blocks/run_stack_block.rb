class RunStackBlock < AshFrame::Block
  require :stack, :event

  def logic
    stack.frames.inject(event) do |memo, frame|
      block = RunFrameBlock.call frame: frame, event: memo

      return if block.logic_result.nil?

      block.logic_result
    end
  end
end
