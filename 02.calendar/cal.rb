#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'date'

MIN_YEAR = 1970
MAX_YEAR = 2100

options = ARGV.getopts('m:y:')

# 引数チェック
if options['y'] && (MIN_YEAR..MAX_YEAR).cover?(options['y'].to_i) == false
  puts "#{File.basename($PROGRAM_NAME, '.*')}: year `#{options['y']}' not in range #{MIN_YEAR}..#{MAX_YEAR}"
  exit
end

if options['m'] && (1..12).cover?(options['m'].to_i) == false
  puts "#{File.basename($PROGRAM_NAME, '.*')}: #{options['m']} is neither a month number (1..12) nor a name"
  exit
end

today = Date.today
# 引数指定がなければ今日の月、年を設定
month = options['m']&.to_i || today.month
year = options['y']&.to_i || today.year
beginning_of_month = Date.new(year, month, 1) # 月初
end_of_month = Date.new(year, month, -1) # 月末

# print部分
print "      #{month}月 #{year}
#{%w[日 月 火 水 木 金 土].join(' ')}\n"

(beginning_of_month..end_of_month).each do |date|
  target_day = date.day # 日付取得
  target_wday = date.wday # 曜日取得

  # 1日より前の未設定部分を空白表示
  print('   ' * target_wday) if target_day == 1

  display_date = target_day.to_s.rjust(2) # 右詰め表示
  # 今日の日付部分を反転
  display_date = "\e[47m\e[30m#{display_date}\e[0m" if date == today
  print "#{display_date} " # 余白調整（スペースを1つ入れる）

  print "\n" if target_wday == 6 # 土曜で改行
end
print "\n"
