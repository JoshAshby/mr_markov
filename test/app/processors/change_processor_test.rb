require 'test_helper'

class ChangeProcessorTest < MiniTest::Test
  def test_empty_state
    processor = ChangeProcessor.new options: { 'from' => 'test' }, state: {}

    action, result = catch(:halt) do
      assert processor.handle
    end

    assert_equal :merge, action
    assert_equal({}, result)
    assert_includes processor.state, 'last'
  end

  def test_different_state
    processor = ChangeProcessor.new options: { 'from' => 'test' }, state: { 'last' => '12345' }

    action, result = catch(:halt) do
      assert processor.handle
    end

    assert_equal :merge, action
    assert_equal({}, result)
    assert_includes processor.state, 'last'
  end

  def test_same_state
    processor = ChangeProcessor.new options: { 'from' => 'test' }, state: {}

    action, result = catch(:halt) do
      assert processor.handle
    end

    state = processor.state

    processor = ChangeProcessor.new options: { 'from' => 'test' }, state: state

    action, result = catch(:halt) do
      assert processor.handle
    end

    assert_equal :cancel, action
    assert_equal({}, result)
    assert_includes processor.state, 'last'
  end
end
