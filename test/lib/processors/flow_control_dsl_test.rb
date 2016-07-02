require 'test_helper'

class Processors::FlowControlTest < MiniTest::Test
  def test_cancel_empty
    processor_klass = Class.new do
      include Processors::FlowControlDSL

      def handle
        cancel!
      end
    end

    processor = processor_klass.new

    assert_throws :halt do
      processor.handle
    end
  end

  def test_cancel
    expected = { sample: :test, batman: :awesome }

    processor_klass = Class.new do
      include Processors::FlowControlDSL

      def handle
        cancel!({ sample: :test }, batman: :awesome)
      end
    end

    processor = processor_klass.new

    assert_throws :halt do
      processor.handle
    end

    assert_equal expected, processor.result
  end

  def test_propagate_empty
    processor_klass = Class.new do
      include Processors::FlowControlDSL

      def handle
        propagate!
      end
    end

    processor = processor_klass.new

    assert_throws :halt do
      processor.handle
    end
  end

  def test_propagate
    expected = { sample: :test, batman: :awesome }

    processor_klass = Class.new do
      include Processors::FlowControlDSL

      def handle
        propagate!({ sample: :test }, batman: :awesome)
      end
    end

    processor = processor_klass.new

    assert_throws :halt do
      processor.handle
    end

    assert_equal expected, processor.result
  end

  def test_merge_empty
    processor_klass = Class.new do
      include Processors::FlowControlDSL

      def handle
        merge!
      end
    end

    processor = processor_klass.new

    assert_throws :halt do
      processor.handle
    end
  end

  def test_merge
    expected = { sample: :test, batman: :awesome }

    processor_klass = Class.new do
      include Processors::FlowControlDSL

      def handle
        merge!({ sample: :test }, batman: :awesome)
      end
    end

    processor = processor_klass.new

    assert_throws :halt do
      processor.handle
    end

    assert_equal expected, processor.result
  end

  def test_pass_through
    processor_klass = Class.new do
      include Processors::FlowControlDSL

      def handle
        pass_through!
      end
    end

    processor = processor_klass.new

    assert_throws :halt do
      processor.handle
    end
  end
end
