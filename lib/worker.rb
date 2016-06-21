class Worker
  include Celluloid

  class << self
    def asyncer
      @asyncer ||= -> (res) {}
    end

    def scheduler
      @scheduler ||= -> (res, start_time:, repeat_delta:) {}
    end

    def set_asyncer &block
      @asyncer = block
    end

    def set_scheduler &block
      @scheduler = block
    end

    def perform_async *args, **opts
      res = serialize_args(*args, **opts)

      asyncer.call res

      true
    end

    def schedule_async *args, start_time:, repeat_delta:, **opts
      res = serialize_args(*args, **opts)

      scheduler.call res, start_time: start_time, repeat_delta: repeat_delta

      true
    end

    def serialize_args *args, **opts
      opts = opts.inject({}) do |memo, (name, value)|
        case
        when value.kind_of?(Proc)
          fail "Can't serialize procs!"
        when value.respond_to?(:to_global_id)
          value = value.to_global_id.to_s
          name  = :"#{ name }_gid"
        end

        memo[name] = value
        memo
      end

      JSON.dump({ args: args, opts: opts })
    end

    def deserialize_args raw
      data = JSON.parse raw

      args = data['args']
      opts = data['opts'].symbolize_keys unless data['opts'] == {}

      opts.keys.each do |key|
        keys = key.to_s

        case
        when keys.end_with?('_gid')
          opts[keys.gsub(/_gid$/, '').to_sym]  = GlobalID::Locator.locate opts[key]
          opts.delete key
        end
      end

      [ args, opts ]
    end
  end

  def ack!
    @return_value = :ack
  end

  def reject!
    @return_value = :ack
  end

  def requeue!
    @return_value = :ack
  end

  def perform *args
    fail NotImplementedError
  end

  def work msg
    ack!

    args, opts = self.class.deserialize_args(msg)

    func = method(:perform)

    if func.parameters.none?{ |type, name| type == :keyrest }
      wanted_parameters = func.parameters.select{ |type, name| type == :keyreq }.map(&:second)
      opts = opts.slice(*wanted_parameters)
    end

    perform(*args, **opts)

    @return_value
  end
end
