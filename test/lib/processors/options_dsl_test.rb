require 'test_helper'

class Processors::OptionsDSLTest < MiniTest::Test
  def test_setup_options
    processor_klass = Class.new do
      include Processors::OptionsDSL

      setup_options do
      end
    end

    assert processor_klass.options

    assert_kind_of Hash, processor_klass.options
  end

  def test_sets_required
    processor_klass = Class.new do
      include Processors::OptionsDSL

      setup_options do
        required :sample
      end

      def initialize(options:)
        setup_options! options
      end
    end

    processor = processor_klass.new options: { 'sample' => :test }

    assert processor
    assert_instance_of processor_klass, processor

    assert processor.options[:sample] = :test
  end

  def test_ignores_symbol_keys
    processor_klass = Class.new do
      include Processors::OptionsDSL

      setup_options do
        required :sample
      end

      def initialize(options:)
        setup_options! options
      end
    end

    assert_raises ArgumentError do
      processor_klass.new options: { sample: :test }
    end

    assert processor_klass.new options: { 'sample' => :test }
  end

  def test_sets_optional_default
    processor_klass = Class.new do
      include Processors::OptionsDSL

      setup_options do
        optional sample: :test
      end

      def initialize(options:)
        setup_options! options
      end
    end

    processor = processor_klass.new options: {}

    assert processor
    assert_instance_of processor_klass, processor

    assert processor.options[:sample] = :test
  end

  def test_sets_optional_provided
    processor_klass = Class.new do
      include Processors::OptionsDSL

      setup_options do
        optional sample: :test
      end

      def initialize(options:)
        setup_options! options
      end
    end

    processor = processor_klass.new options: { 'sample' => :batman }

    assert processor
    assert_instance_of processor_klass, processor

    assert processor.options[:sample] = :batman
  end

  def test_sets_optional_symbol_ignored
    processor_klass = Class.new do
      include Processors::OptionsDSL

      setup_options do
        optional sample: :test
      end

      def initialize(options:)
        setup_options! options
      end
    end

    processor = processor_klass.new options: { sample: :batman }

    assert processor
    assert_instance_of processor_klass, processor

    assert processor.options[:sample] = :test
  end
end
