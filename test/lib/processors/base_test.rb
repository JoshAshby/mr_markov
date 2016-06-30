require 'test_helper'

class ProcessorsBaseTest < MiniTest::Test
  def setup
    Processors.unregister :test
  end

  # Class methods
  def test_register
    processor_klass = Class.new(Processors::Base) do
      register_as :test
    end

    res = Processors.get(:test)
    assert res
    assert_equal processor_klass, res
  end

  def test_unregister
    processor_klass = Class.new(Processors::Base) do
      register_as :test
    end

    assert_equal :test, processor_klass.registered_as

    assert Processors.get(:test)
    assert_nil processor_klass.unregister
    refute Processors.get(:test)

    refute processor_klass.registered_as
  end

  def test_setup_options
    processor_klass = Class.new(Processors::Base) do
      setup_options do
      end
    end

    assert processor_klass.options

    assert_kind_of Hash, processor_klass.options
  end

  # On to instance methods
  def test_sets_required
    processor_klass = Class.new(Processors::Base) do
      setup_options do
        required :sample
      end
    end

    processor = processor_klass.new options: { 'sample' => :test }

    assert processor
    assert_instance_of processor_klass, processor

    assert processor.options[:sample] = :test
  end

  def test_ignores_symbol_keys
    processor_klass = Class.new(Processors::Base) do
      setup_options do
        required :sample
      end
    end

    assert_raises ArgumentError do
      processor_klass.new options: { sample: :test }
    end

    assert processor_klass.new options: { 'sample' => :test }
  end

  def test_sets_optional_default
    processor_klass = Class.new(Processors::Base) do
      setup_options do
        optional sample: :test
      end
    end

    processor = processor_klass.new options: {}

    assert processor
    assert_instance_of processor_klass, processor

    assert processor.options[:sample] = :test
  end

  def test_sets_optional_provided
    processor_klass = Class.new(Processors::Base) do
      setup_options do
        optional sample: :test
      end
    end

    processor = processor_klass.new options: { 'sample' => :batman }

    assert processor
    assert_instance_of processor_klass, processor

    assert processor.options[:sample] = :batman
  end

  def test_sets_optional_symbol_ignored
    processor_klass = Class.new(Processors::Base) do
      setup_options do
        optional sample: :test
      end
    end

    processor = processor_klass.new options: { sample: :batman }

    assert processor
    assert_instance_of processor_klass, processor

    assert processor.options[:sample] = :test
  end
end
