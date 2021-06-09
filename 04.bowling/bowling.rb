#!/usr/bin/env ruby
# frozen_string_literal: true

scores = ARGV[0].split(',')
sum = 0
is_skip = false
frame_count = 1

def calc_score(score)
  score == 'X' ? 10 : score.to_i
end

scores.each_with_index do |score, index|
  if is_skip
    is_skip = false
    next
  end

  next_first_score = scores[index + 1]
  next_second_score = scores[index + 2]

  if score == 'X' || frame_count == 10 # strike or frame 10
    sum += calc_score(score)
    sum += calc_score(next_first_score)
    sum += calc_score(next_second_score)
    break if frame_count == 10
  elsif score.to_i + next_first_score.to_i == 10 # spare
    sum += 10
    sum += calc_score(next_second_score)
    is_skip = true
  else
    sum += score.to_i + next_first_score.to_i
    is_skip = true
  end

  frame_count += 1
end

puts sum
