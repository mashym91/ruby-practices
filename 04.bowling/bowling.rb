#!/usr/bin/env ruby
# frozen_string_literal: true

score_string = ARGV[0]

shots = []
shots_per_game = []
count = 1

score_split = score_string.split(',')
score_split.each_with_index do |score, index|
  shots_per_game << score

  if score == 'X' || count == 2
    shots << shots_per_game
    shots_per_game = []
    count = 1
  else
    count += 1
  end

  next unless shots.count == 10

  if score == 'X' # 10 frame is strike
    shots.last << score_split[index + 1]
    shots.last << score_split[index + 2]
  elsif score_split[index - 1].to_i + score.to_i == 10  # spare
    shots.last << score_split[index + 1]
  end
  break
end

# calc score
