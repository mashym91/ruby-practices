#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'date'
opt = OptionParser.new

params = {}
opt.on('-m VAL', 'specified month') { |v| params[:month] = Integer(v) }
opt.on('-y VAL', 'specified year') { |v| params[:year] = Integer(v) }
opt.parse!(ARGV)

today = Date.today
month = (1..12).cover?(params[:month]) ? params[:month] : today.month
year = (1970..2100).cover?(params[:year]) ? params[:year] : today.year

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

  print "#{num.to_s.rjust(2)} " # 右詰め表示 + 余白調整（スペースを1つ入れる）

  # 土曜で改行
  print "\n" if Date.new(year, month, num).wday == 6
end
print "\n"
