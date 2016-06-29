class RunStackBlock < AshFrame::Block
  require :stack, :event

  def logic
    catch(:halt) do
      stack.frames.inject(event) do |memo, frame|
        block = sub_call RunFrameBlock, frame: frame, event: memo

        block.logic_result || {}
      end
    end
  end
end
