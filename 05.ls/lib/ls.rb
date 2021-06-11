#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative './ls_command'

options = ARGV.getopts('alr').select { |_key, value| value == true }.keys
file_or_dir = ARGV[0]

ls = LsCommand.new(options, file_or_dir)
puts ls.exec
