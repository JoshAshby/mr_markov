class Processors
  # Base setup for processors and the DSL definitions for a processors settings
  class Base
    include RegistryDSL

    include OptionsDSL
    include OptionsMetaDSL

    include FlowControlDSL

    attr_reader :logger, :state

    def initialize(options:, state: {}, logger: nil)
      @logger    = logger || Logger.new(STDOUT)
      @state     = state

      setup_options! options
    end
  end
end
