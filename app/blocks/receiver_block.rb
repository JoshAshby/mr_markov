class ReceiverBlock < AshFrame::Block
  require :stack, :event

  def logic
    stack.frames.inject(event) do |memo, frame|
      log_file           = StringIO.new
      logger             = Logger.new log_file

      frame_processor    = Processors.get frame.processor
      interpolated_options = interpolate frame.options, using: memo

      processor = nil
      result    = nil
      cancel    = false

      begin
        processor = frame_processor.new options: interpolated_options, state: frame.state.to_h, logger: logger
        result    = processor.handle
        cancel    = processor.cancel
      rescue => e
        logger.error e
        result = {}
        cancel = true
      end

      log_file.rewind

      frame.update state: processor.state.to_h

      Result.create frame: frame, result: result
      Log.create    frame: frame, log: log_file.read

      log_file.close

      return result if cancel

      result
    end
  end

  protected

  def interpolate(frame_options, using:)
    liquid_context = Liquid::Context.new using.deep_stringify_keys

    frame_options.transform_values do |value|
      next Liquid::Template.parse(value).render!(liquid_context) if value.kind_of? String
      value
    end
  end
end
