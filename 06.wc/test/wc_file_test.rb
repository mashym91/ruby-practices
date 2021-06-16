# frozen_string_literal: true

require 'minitest/autorun'

require_relative '../lib/wc/file'

class WcFileTest < Minitest::Test
  def test_init
    ls = WC::File.new('./test/data/wc_test1.txt')
    assert_equal 6, ls.lines
    assert_equal 45, ls.words
    assert_equal 201, ls.bytes
  end
end
