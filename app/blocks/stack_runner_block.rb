class StackRunnerBlock < AshFrame::Block
  include Celluloid

  def self.async_call(*args, **opts)
    new(*args, **opts).async.send :run
  end

  require :stack, :event

  def logic
    stack.frames.inject(event) do |memo, frame|
      log_file             = StringIO.new
      logger               = Logger.new log_file

      frame_processor      = Processors.get frame.processor
      interpolated_options = interpolate frame.options, using: memo

      processor            = frame_processor.new(options: interpolated_options, state: frame.state.to_h, logger: logger)

      begin
        processor.handle
      rescue => e
        logger.error e
      end

      fail "State is not a hash like object!" unless processor.state.respond_to? :to_h
      frame.update state: processor.state.to_h
      frame.save

      fail "Result is not a hash like object!" unless processor.result.respond_to? :to_h
      Result.create frame: frame, result: processor.result.to_h

      log_file.rewind
      Log.create frame: frame, log: log_file.read
      log_file.close

      return processor.result unless processor.propagate

      processor.result
    end
  end

  protected

  def interpolate(frame_options, using:)
    liquid_context = Liquid::Context.new using.deep_stringify_keys

    frame_options.transform_values do |value|
      next Liquid::Template.parse(value).render!(liquid_context) if value.kind_of? String
      next interpolate value, using: using if value.kind_of? Hash
      value
    end
  end
end
