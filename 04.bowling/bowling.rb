#!/usr/bin/env ruby
# frozen_string_literal: true

scores = ARGV[0].split(',')
sum = 0
is_skip = false
frame = 1

def convert_score_int(score)
  score == 'X' ? 10 : score.to_i
end

scores.each_with_index do |score, index|
  if is_skip
    is_skip = false
    next
  end

  next_first_score = scores[index + 1]
  next_second_score = scores[index + 2]

  if score == 'X' || frame == 10 # strike or frame 10
    sum += convert_score_int(score)
    sum += convert_score_int(next_first_score)
    sum += convert_score_int(next_second_score)
    break if frame == 10
  elsif score.to_i + next_first_score.to_i == 10 # spare
    sum += 10
    sum += convert_score_int(next_second_score)
    is_skip = true
  else
    sum += score.to_i + next_first_score.to_i
    is_skip = true
  end

  frame += 1
end

puts sum
