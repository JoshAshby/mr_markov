require 'test_helper'

class ProcessorsTest < MiniTest::Test
  def setup
    Processors.unregister :test
  end

  def test_registry
    assert_kind_of Hash, Processors.registry
  end

  def test_register
    fake_thing = -> (v) { next }

    assert Processors.register(:test, as: fake_thing)
  end

  def test_unregister
    fake_thing = -> (v) { next }

    Processors.register(:test, as: fake_thing)
    assert Processors.unregister(:test)
  end

  def test_get
    fake_thing = -> (v) { next }

    assert Processors.register(:test, as: fake_thing)

    res = Processors.get(:test)
    assert res
    assert_equal fake_thing, res

    assert Processors.unregister(:test)
    refute Processors.get(:test)
  end
end
