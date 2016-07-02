class WebsiteProcessor < Processors::Base
  register_as :website

  setup_options do
    required :url

    optional verb: :get,
             user_agent: 'xkcd-scraper v4.20yolo',
             headers: {},
             body: nil,
             success_codes: (200..300),
             redirect_limit: 3
  end

  meta_options do
    url            type: :string

    verb           type: :enum, choices: [ :get, :post, :put, :patch, :delete, :options, :head ]
    user_agent     type: :string
    headers        type: :hash, keys_type: :string, values_type: :string
    body           type: :string
    success_codes  type: :integer
    redirect_limit type: :integer
  end

  def handle
    response = faraday.send options[:verb].to_sym, options[:url], options[:body]

    unless options[:success_codes].include? response.status
      logger.error "Did not get a successful status code: #{ response.status }"
      cancel!
    end

    propagate!({
      status: response.status,
      headers: response.headers,
      body: response.body.force_encoding('utf-8')
    })
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
