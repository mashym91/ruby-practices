# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/ls/file'

class LsFileTest < Minitest::Test
  TEST_FILE = './test/ls_test_dir/c.txt'

  def test_build_detail_info
    ls_file = LS::File.new(TEST_FILE)
    ls_file.stub(:permission, 'rwxrwxr--') do
      ls_file.stub(:owner_name, 'dummy') do
        ls_file.stub(:group_name, 'dummy') do
          ls_file.stub(:timestamp, '6 18 22:46') do
            result = '-rwxrwxr--  1 dummy  dummy  0  6 18 22:46 ./test/ls_test_dir/c.txt'
            assert_equal result, ls_file.build_detail_info
          end
        end
      end
    end
  end
end
