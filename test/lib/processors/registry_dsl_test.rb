require 'test_helper'

class Processors::RegistryTest < MiniTest::Test
  def setup
    Processors.unregister :test
  end

  def teardown
    Processors.unregister :test
  end

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
end
