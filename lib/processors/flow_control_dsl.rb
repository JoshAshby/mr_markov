class Processors
  module FlowControlDSL
    extend ActiveSupport::Concern

    def result
      @result ||= {}
    end

    def cancel! data={}, **opts
      @result = data.merge(opts)
      throw :halt, [ :cancel, @result ]
    end

    def propagate! data={}, **opts
      @result = data.merge(opts)
      throw :halt, [ :propagate, @result ]
    end

    def merge! data={}, **opts
      @result = data.merge(opts)
      throw :halt, [ :merge, @result ]
    end

    def pass_through!
      throw :halt, [ :pass_through, nil ]
    end
  end
end
