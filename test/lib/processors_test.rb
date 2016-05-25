require 'test_helper'

class ProcessorsTest < MiniTest::Test
  def test_registry
    assert_kind_of Array, Processors.registry
  end
end
