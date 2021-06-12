# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/ls_command'

class LsCommandTest < Minitest::Test
  TEST_DIR = './test/ls_test_dir'
  TEST_FILE = './test/ls_test_dir/c.txt'

  def test_no_dir_no_option
    ls = LsCommand.new([], nil)
    assert_equal "lib\ttest\t\t\n", ls.exec
  end

  def test_dir_no_option
    ls = LsCommand.new([], TEST_DIR)
    result = <<~TEXT
      a.txt\te.txt\ti.txt\t
      b.txt\tf.txt\tj.txt\t
      c.txt\tg.txt\tk.txt\t
      d.txt\th.txt\t\t
    TEXT
    assert_equal result, ls.exec
  end

  def test_file_no_option
    ls = LsCommand.new([], TEST_FILE)
    assert_equal "./test/ls_test_dir/c.txt\t\t\t\n", ls.exec
  end

  def test_dir_a_options
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

  def test_file_a_options
    ls = LsCommand.new(['a'], TEST_FILE)
    assert_equal "./test/ls_test_dir/c.txt\t\t\t\n", ls.exec
  end

  def test_dir_r_options
    ls = LsCommand.new(['r'], TEST_DIR)
    result = <<~TEXT
      k.txt\tg.txt\tc.txt\t
      j.txt\tf.txt\tb.txt\t
      i.txt\te.txt\ta.txt\t
      h.txt\td.txt\t\t
    TEXT
    assert_equal result, ls.exec
  end

  def test_file_r_options
    ls = LsCommand.new(['r'], TEST_FILE)
    assert_equal "./test/ls_test_dir/c.txt\t\t\t\n", ls.exec
  end

  def test_dir_l_options
    ls = LsCommand.new(['l'], TEST_DIR)
    result = <<~TEXT
      drwxr-xr-x  3 mashym91  staff  96  6 11 18:43 a.txt
      drwxr-xr-x  3 mashym91  staff  96  6 11 18:43 b.txt
      -rw-r--r--  1 mashym91  staff  0  6 11 18:42 c.txt
      -rw-r--r--  1 mashym91  staff  0  6 11 18:42 d.txt
      -rw-r--r--  1 mashym91  staff  0  6 11 18:42 e.txt
      -rw-r--r--  1 mashym91  staff  0  6 11 18:42 f.txt
      -rw-r--r--  1 mashym91  staff  0  6 11 18:42 g.txt
      -rw-r--r--  1 mashym91  staff  0  6 11 18:42 h.txt
      -rw-r--r--  1 mashym91  staff  0  6 11 18:42 i.txt
      -rw-r--r--  1 mashym91  staff  0  6 11 16:36 j.txt
      -rw-r--r--  1 mashym91  staff  0  6 11 16:36 k.txt
    TEXT
    # ヒアドキュメントで最後に改行コードが入るので削除
    assert_equal result.gsub(/\n$/, ''), ls.exec
  end

  def test_file_l_options
    ls = LsCommand.new(['l'], TEST_FILE)
    assert_equal '-rw-r--r--  1 mashym91  staff  0  6 11 18:42 ./test/ls_test_dir/c.txt', ls.exec
  end

  def test_dir_all_options
    ls = LsCommand.new(%w[a l r], TEST_DIR)
    result = <<~TEXT
      -rw-r--r--  1 mashym91  staff  0  6 11 16:36 k.txt
      -rw-r--r--  1 mashym91  staff  0  6 11 16:36 j.txt
      -rw-r--r--  1 mashym91  staff  0  6 11 18:42 i.txt
      -rw-r--r--  1 mashym91  staff  0  6 11 18:42 h.txt
      -rw-r--r--  1 mashym91  staff  0  6 11 18:42 g.txt
      -rw-r--r--  1 mashym91  staff  0  6 11 18:42 f.txt
      -rw-r--r--  1 mashym91  staff  0  6 11 18:42 e.txt
      -rw-r--r--  1 mashym91  staff  0  6 11 18:42 d.txt
      -rw-r--r--  1 mashym91  staff  0  6 11 18:42 c.txt
      drwxr-xr-x  3 mashym91  staff  96  6 11 18:43 b.txt
      drwxr-xr-x  3 mashym91  staff  96  6 11 18:43 a.txt
      drwxr-xr-x  4 mashym91  staff  128  6 11 17:16 ..
      drwxr-xr-x  13 mashym91  staff  416  6 11 22:59 .
    TEXT
    # ヒアドキュメントで最後に改行コードが入るので削除
    assert_equal result.gsub(/\n$/, ''), ls.exec
  end

  def test_file_all_options
    ls = LsCommand.new(%w[a l r], TEST_FILE)
    assert_equal '-rw-r--r--  1 mashym91  staff  0  6 11 18:42 ./test/ls_test_dir/c.txt', ls.exec
  end
end
