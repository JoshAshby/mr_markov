class WebsiteProcessor < Processors::Base
  register_as :website

  meta_options do
    url is_a: :string

    verb is_a: :enum, choices: [ :get, :post, :put, :patch, :delete, :options, :head ]
    user_agent is_a: :string
    headers is_a: :hash, keys_are: :string, values_are: :string
    body is_a: :string
    success_codes is_a: :integer
    redirect_limit is_a: :integer
  end

  setup_options do
    required :url

    optional verb: :get,
             user_agent: 'xkcd-scraper v4.20yolo',
             headers: {},
             body: nil,
             success_codes: (200..300),
             redirect_limit: 3
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
