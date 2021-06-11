# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/ls_command'
require 'byebug'

class LsCommandTest < Minitest::Test
  TEST_DIR = './test/ls_test_dir'

  def test_exec_no_option_no_dir
    ls = LsCommand.new([], nil)
    assert_equal "lib\ttest\t\t\n", ls.exec
  end

  def test_exec_no_option
    ls = LsCommand.new([], TEST_DIR)
    result = <<~TEXT
      a.txt\te.txt\ti.txt\t
      b.txt\tf.txt\tj.txt\t
      c.txt\tg.txt\tk.txt\t
      d.txt\th.txt\t\t
    TEXT
    assert_equal result, ls.exec
  end

  def test_exec_with_a_options
    ls = LsCommand.new(['a'], TEST_DIR)
    result = <<~TEXT
      .\td.txt\ti.txt\t
      ..\te.txt\tj.txt\t
      a.txt\tf.txt\tk.txt\t
      b.txt\tg.txt\t\t
      c.txt\th.txt\t\t
    TEXT
    assert_equal result, ls.exec
  end

  # def test_exec_with_l_options
  #   ls = LsCommand.new(['l'], TEST_DIR)
  #   result <<~TEXT

  #   TEXT
  #   assert_equal result, ls.exec
  # end

  def test_exec_with_r_options
    ls = LsCommand.new(['r'], TEST_DIR)
    result = <<~TEXT
      k.txt\tg.txt\tc.txt\t
      j.txt\tf.txt\tb.txt\t
      i.txt\te.txt\ta.txt\t
      h.txt\td.txt\t\t
    TEXT
    assert_equal result, ls.exec
  end

  #def test_exec_with_many_options
  #  ls = LsCommand.new(['alr'], TEST_DIR)
  #  result <<~TEXT

  #  TEXT
  #  assert_equal result, ls.exec
  #end
end
