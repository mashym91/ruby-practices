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
wdays = %w[日 月 火 水 木 金 土]
beginning_of_month_wday = wdays[beginning_of_month.wday] # 月初の曜日
wday_index = wdays.index(beginning_of_month_wday) # 曜日index

# print部分
print "      #{month}月 #{year}
#{wdays.join(' ')}\n"

(beginning_of_month.day..end_of_month.day).each do |num|
  # 1日より前の未設定部分を空白表示
  print ('   ' * wday_index).to_s if num == 1

  display_date = num.to_s.rjust(2) # 右詰め表示
  # 今日の日付部分を反転
  display_date = "\e[47m\e[30m#{display_date}\e[0m" if month == today.month && year == today.year && num == today.day
  print "#{display_date} " # 余白調整（スペースを1つ入れる）

  # 土曜で改行
  print "\n" if Date.new(year, month, num).wday == 6
end
print "\n"
