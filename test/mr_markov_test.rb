require_relative './test_helper'

class MrMarkovTest < MiniTest::Test
  def test_environment
    assert AshFrame.environment == :test
  end
end
