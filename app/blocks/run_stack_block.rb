class RunStackBlock < AshFrame::Block
  require :stack, :event

  def logic
    log_file             = StringIO.new
    logger               = Logger.new log_file

    logger.info "Starting to run stack #{ stack.name }"

    result = catch(:halt) do
      stack.frames.inject(event) do |memo, frame|
        block = sub_call RunFrameBlock, frame: frame, event: memo, logger: logger

        block.logic_result || {}
      end
    end

    fail "Result is not a hash like object!" unless result.respond_to? :to_h

    log_file.rewind
    run = stack.add_stack_run result: result, log: log_file.read
    log_file.close

    run
  end
end
