require 'test_helper'

class ProcessorsTest < MiniTest::Test
  def setup
    Processors.unregister :test
  end

  def test_registry
    assert_kind_of Hash, Processors.registry
  end

  def test_register
    fake_processor = Class.new(Processors::Base)

    assert Processors.register(:test, as: fake_processor)
  end

  def test_invalid_register
    fake_processor = Class.new

    assert_raises ArgumentError do
      Processors.register(:test, as: fake_processor)
    end
  end

  def test_unregister
    fake_processor = Class.new(Processors::Base)

    Processors.register(:test, as: fake_processor)
    assert Processors.unregister(:test)
  end

  def test_get
    fake_processor = Class.new(Processors::Base)

    assert Processors.register(:test, as: fake_processor)

    res = Processors.get(:test)
    assert res
    assert_equal fake_processor, res

    assert Processors.unregister(:test)
    refute Processors.get(:test)
  end
end
