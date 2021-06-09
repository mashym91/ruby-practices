#!/usr/bin/env ruby
# frozen_string_literal: true

scores = ARGV[0].split(',')
sum = 0
is_jump = false
frame_count = 1

def calc_score(score)
  if score == 'X'
    10
  else
    score.to_i
  end
end

scores.each_with_index do |score, index|
  if is_jump
    is_jump = false
    next
  end

  if frame_count == 10
    sum += calc_score(score)
    sum += calc_score(scores[index + 1])
    sum += calc_score(scores[index + 2]) if scores[index + 2]
    break
  elsif score == 'X' # strike
    sum += 10
    # add next 2shot
    sum += calc_score(scores[index + 1])
    sum += calc_score(scores[index + 2])
  elsif score.to_i + (scores[index + 1]).to_i == 10 # spare
    sum += 10
    sum += calc_score(scores[index + 2]) # add next 1shot
    is_jump = true
  else
    # add 2shot
    sum += score.to_i + (scores[index + 1]).to_i
    is_jump = true
  end

  frame_count += 1
end

puts sum
