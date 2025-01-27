# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/ls/command'

# rubocop:disable Metrics/ClassLength
class LsCommandTest < Minitest::Test
  TEST_DIR = './test/ls_test_dir'
  TEST_FILE = './test/ls_test_dir/c.txt'

  def test_no_dir_no_option
    ls = LS::Command.new([], nil)
    assert_equal "lib\ttest\t\t\n", ls.exec
  end

  # ディレクトリ指定
  def test_dir_no_option
    ls = LS::Command.new([], TEST_DIR)
    result = <<~TEXT
      a.txt\te.txt\ti.txt\t
      b.txt\tf.txt\tj.txt\t
      c.txt\tg.txt\tk.txt\t
      d.txt\th.txt\t\t
    TEXT
    assert_equal result, ls.exec
  end

  def test_dir_a_options
    ls = LS::Command.new(['a'], TEST_DIR)
    result = <<~TEXT
      .\td.txt\ti.txt\t
      ..\te.txt\tj.txt\t
      a.txt\tf.txt\tk.txt\t
      b.txt\tg.txt\t\t
      c.txt\th.txt\t\t
    TEXT
    assert_equal result, ls.exec
  end

  def test_dir_r_options
    ls = LS::Command.new(['r'], TEST_DIR)
    result = <<~TEXT
      k.txt\tg.txt\tc.txt\t
      j.txt\tf.txt\tb.txt\t
      i.txt\te.txt\ta.txt\t
      h.txt\td.txt\t\t
    TEXT
    assert_equal result, ls.exec
  end

  def test_dir_l_options
    ls = LS::Command.new(['l'], TEST_DIR)
    files_detail_info = [
      'drwxrwxr-x  3 dummy  dummy  96  6 18 22:55 a.txt',
      'drwxrwxr-x  3 dummy  dummy  96  6 18 22:55 b.txt',
      '-rw-rw-r--  1 dummy  dummy  0  6 18 22:55 c.txt'
    ]

    ls.stub(:files_detail_info, files_detail_info) do
      result = <<~TEXT
        total 0
        drwxrwxr-x  3 dummy  dummy  96  6 18 22:55 a.txt
        drwxrwxr-x  3 dummy  dummy  96  6 18 22:55 b.txt
        -rw-rw-r--  1 dummy  dummy  0  6 18 22:55 c.txt
      TEXT
      assert_equal result.gsub(/\n$/, ''), ls.exec # ヒアドキュメントで最後に改行コードが入るので削除
    end
  end

  def test_dir_al_options
    ls = LS::Command.new(%w[a l], TEST_DIR)
    result = <<~TEXT
      total 0
      drwxr-xr-x  13 mashym91  staff  416  6 11 22:59 .
      drwxr-xr-x  4 mashym91  staff  128  6 11 17:16 ..
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
    assert_equal result.gsub(/\n$/, ''), ls.exec # ヒアドキュメントで最後に改行コードが入るので削除
  end

  def test_dir_ar_options
    ls = LS::Command.new(%w[a r], TEST_DIR)
    result = <<~TEXT
      k.txt\tf.txt\ta.txt\t
      j.txt\te.txt\t..\t
      i.txt\td.txt\t.\t
      h.txt\tc.txt\t\t
      g.txt\tb.txt\t\t
    TEXT
    assert_equal result, ls.exec
  end

  def test_dir_lr_options
    ls = LS::Command.new(%w[l r], TEST_DIR)
    result = <<~TEXT
      total 0
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
    TEXT
    assert_equal result.gsub(/\n$/, ''), ls.exec # ヒアドキュメントで最後に改行コードが入るので削除
  end

  def test_dir_all_options
    ls = LS::Command.new(%w[a l r], TEST_DIR)
    result = <<~TEXT
      total 0
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
    assert_equal result.gsub(/\n$/, ''), ls.exec # ヒアドキュメントで最後に改行コードが入るので削除
  end

  # ファイル指定
  def test_file_no_option
    ls = LS::Command.new([], TEST_FILE)
    assert_equal "./test/ls_test_dir/c.txt\t\t\t\n", ls.exec
  end

  def test_file_l_options
    ls = LS::Command.new(['l'], TEST_FILE)
    result = <<~TEXT
      total 0
      -rw-r--r--  1 mashym91  staff  0  6 11 18:42 ./test/ls_test_dir/c.txt
    TEXT
    assert_equal result.gsub(/\n$/, ''), ls.exec # ヒアドキュメントで最後に改行コードが入るので削除
  end

  def test_file_a_options
    ls = LS::Command.new(['a'], TEST_FILE)
    assert_equal "./test/ls_test_dir/c.txt\t\t\t\n", ls.exec
  end

  def test_file_r_options
    ls = LS::Command.new(['r'], TEST_FILE)
    assert_equal "./test/ls_test_dir/c.txt\t\t\t\n", ls.exec
  end

  def test_file_all_options
    ls = LS::Command.new(%w[a l r], TEST_FILE)
    result = <<~TEXT
      total 0
      -rw-r--r--  1 mashym91  staff  0  6 11 18:42 ./test/ls_test_dir/c.txt
    TEXT
    assert_equal result.gsub(/\n$/, ''), ls.exec # ヒアドキュメントで最後に改行コードが入るので削除
  end

  def test_file_al_options
    ls = LS::Command.new(%w[a l], TEST_FILE)
    result = <<~TEXT
      total 0
      -rw-r--r--  1 mashym91  staff  0  6 11 18:42 ./test/ls_test_dir/c.txt
    TEXT
    assert_equal result.gsub(/\n$/, ''), ls.exec # ヒアドキュメントで最後に改行コードが入るので削除
  end

  def test_file_ar_options
    ls = LS::Command.new(%w[a r], TEST_FILE)
    assert_equal "./test/ls_test_dir/c.txt\t\t\t\n", ls.exec
  end

  def test_file_lr_options
    ls = LS::Command.new(%w[l r], TEST_FILE)
    result = <<~TEXT
      total 0
      -rw-r--r--  1 mashym91  staff  0  6 11 18:42 ./test/ls_test_dir/c.txt
    TEXT
    assert_equal result.gsub(/\n$/, ''), ls.exec # ヒアドキュメントで最後に改行コードが入るので削除
  end
end
# rubocop:enable Metrics/ClassLength
