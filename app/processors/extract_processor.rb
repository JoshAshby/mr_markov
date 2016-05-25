class ExtractProcessor < Processors::Base
  register_as :extract

  setup_options do
    required :from

    optional type: :xpath,
             extract: {}
  end

  def handle
    @extracted_parts = {}

    case options[:type]
    when :json
      json
    else # Assume its an HTML document otherwise
      xml
    end

    @extracted_parts
  end

  protected

  def json
    options[:extract].each do |key, path|
      path = JsonPath.new path
      @extracted_parts[key] = path.on options[:from]
    end
  end

  def xml
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

      @extracted_parts[key] = result
    end
  end
end
