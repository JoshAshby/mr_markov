# Container for basic processor related functionality, along with acting as a
# registry of all processors by a nice easy to use name.
class Processors
  class << self
    def registery
      @@registery ||= []
    end

    def register name, as:
      registery << [ name.to_sym, as ]
    end

    def get name
      name = name.to_sym
      registery.find{ |parts| parts[0] == name }[1]
    end
  end

  # Base setup for processors and the DSL definitions for a processors settings
  class Base
    class << self
      attr_reader :registered_as, :options

      def register_as name
        Processors.register name, as: self
        @registered_as = name
      end

      def setup_options *required, **optional, &block
        @options = OptionsDSL.call(*required, **optional, &block)
      end

      def receive options, event
        new(options, event).handle
      end
    end

    attr_reader :logger, :options, :event

    def initialize raw_options, event, logger: nil
      @logger = logger || Logger.new(STDOUT) # TODO: Fix
      @liquid_context = Liquid::Context.new event.deep_stringify_keys

      @options = {}

      self.class.options.each do |name, settings|
        if  settings.required && ! raw_options.has_key?(name.to_s)
          fail "Invalid options: #{ name } is required but missing"
        end

        value = raw_options[name.to_s] || settings.default
        value = Liquid::Template.parse(value).render!(@liquid_context) if value.kind_of? String

        @options[name] = value
      end

      @event = event
    end
  end

  protected

  class OptionsDSL
    Option = Struct.new :required, :default, :type

    attr_reader :options

    def self.call *required, **optional, &block
      inst = self.new

      inst.required(*required, **optional)
      inst.instance_exec(&block)

      inst.options
    end

    def initialize
      @options = {}
    end

    def required *args, **opts
      args.each{ |arg| @options[arg] = Option.new true }
      opts.each{ |key, value| @options[key] = Option.new false, value, nil }
    end

    alias_method :optional, :required
  end
end

class WebsiteProcessor < Processors::Base
  register_as :website

  setup_options do
    required :url

    optional method: :get,
             user_agent: 'xkcd-scraper v4.20yolo',
             headers: {},
             success_codes: (200..300),
             redirect_limit: 3
  end

  def handle
    response = faraday.send options[:method].to_sym, options[:url]

    status = response.status
    logger.error "Did not get a success status code: #{ status }" and return unless options[:success_codes].include? status

    body = response.body

    {
      status: response.status,
      headers: response.headers,
      body: body
    }
  end

  protected

  def faraday
    @faraday ||= Faraday.new do |builder|
      builder.adapter :excon

      builder.use Faraday::Response::Logger, logger
      builder.use FaradayMiddleware::FollowRedirects, limit: options[:redirect_limit]

      builder.headers = options[:headers] if options[:headers].present?
      builder.headers[:user_agent] = options[:user_agent]
    end
  end
end

class ExtractProcessor < Processors::Base
  register_as :extract

  setup_options do
    required :from

    optional type: :xpath,
             extract: {}
  end

  def handle
    extracted_parts = {}

    case options[:type]
    when :json
      options[:extract].each do |key, path|
        path = JsonPath.new path
        extracted_parts[key] = path.on options[:from]
      end
    else # Assume its an HTML document otherwise
      body_giri = Nokogiri::HTML options[:from]

      options[:extract].each do |key, path|
        nodes = body_giri.xpath path

        # Copied right out of Huginn
        result = nodes.map do |node|
          value = node.xpath '.'
          if value.is_a? Nokogiri::XML::NodeSet
            child = value.first
            if child && child.cdata?
              value = child.text
            end
          end
          case value
          when Float
            # Node#xpath() returns any numeric value as float;
            # convert it to integer as appropriate.
            value = value.to_i if value.to_i == value
          end
          value.to_s
        end

        result = result.first if result.kind_of?(Array) && result.length == 1

        extracted_parts[key] = result
      end
    end

    extracted_parts
  end
end
