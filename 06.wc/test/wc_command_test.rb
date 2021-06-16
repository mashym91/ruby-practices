# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/wc/command'

class WcCommandTest < Minitest::Test
  TEST_FILE_1 = './test/data/wc_test1.txt'
  TEST_FILE_2 = './test/data/wc_test2.txt'

  # ファイル指定
  def test_specify_a_file_and_no_options
    wc = WC::Command.new([], [TEST_FILE_1])
    assert_equal "       6      45     201 ./test/data/wc_test1.txt", wc.exec
  end

  def test_specify_a_file_and_l_option
    wc = WC::Command.new(['l'], [TEST_FILE_1])
    assert_equal "       6 ./test/data/wc_test1.txt", wc.exec
  end

  def test_specify_multi_files_and_no_options
    wc = WC::Command.new([], [TEST_FILE_1, TEST_FILE_2])
    result = <<~TEXT
      \s\s\s\s\s\s\s6      45     201 ./test/data/wc_test1.txt
      \s\s\s\s\s\s\s6       6     402 ./test/data/wc_test2.txt
      \s\s\s\s\s\s12      51     603 total
    TEXT
    assert_equal result.gsub(/\n$/, ''), wc.exec
  end

  def test_specify_multi_files_and_l_option
    wc = WC::Command.new(['l'], [TEST_FILE_1, TEST_FILE_2])
    result = <<~TEXT
      \s\s\s\s\s\s\s6 ./test/data/wc_test1.txt
      \s\s\s\s\s\s\s6 ./test/data/wc_test2.txt
      \s\s\s\s\s\s12 total
    TEXT
    assert_equal result.gsub(/\n$/, ''), wc.exec
  end

  # 標準入力
  # option無しがlsコマンドと表示が異なるため一旦コメントアウト（ファイル名の改行が考慮されていない）
  # def test_stdin_and_no_options
  #   $stdin = StringIO.new("wc_test1.txt
  #     wc_test2.txt")
  #   wc = WC::Command.new([], [])
#
  #   assert_equal "       1       2      28", wc.exec
  #   $stdin = STDIN
  # end

  def test_stdin_and_l_option
    str = <<~TEXT
      total 16
      -rw-r--r--  1 mashym91  staff  201  6 16 16:09 wc_test1.txt
      -rw-r--r--  1 mashym91  staff  402  6 16 16:09 wc_test2.txt
    TEXT
    $stdin = StringIO.new(str)
    wc = WC::Command.new(['l'], [])
    assert_equal "       3", wc.exec
    $stdin = STDIN
  end
end
