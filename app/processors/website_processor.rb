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

    logger.error "Did not get a successful status code!" and return unless options[:success_codes].include? status

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
