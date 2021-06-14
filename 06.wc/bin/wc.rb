#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative '../lib/wc/command'

options = ARGV.getopts('l').select { |_key, value| value == true }.keys
files = ARGV

wc = WC::Command.new(options, files)
puts wc.exec
