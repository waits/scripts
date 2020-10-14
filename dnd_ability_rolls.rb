require 'descriptive_statistics'

ITERATIONS = 100_000

def roll_d6
  rand(6) + 1
end

def best_of(arr, num)
  arr.sort.reverse.take(num)
end

def ability_score
  best_of(4.times.map { roll_d6 }, 3).sum
end

def ability_scores(min = 18)
  sum = 0
  _scores = nil
  until sum >= min
    _scores = 6.times.map { ability_score }
    sum = _scores.sum
  end
  _scores
end

def print_output(scores)
  totals = scores.map(&:sum)

  puts <<~HEREDOC
  ------------------------
  mean:          #{totals.mean.round(1)}
  min:           #{totals.min.to_i}
  max:           #{totals.max.to_i}

  1st:           #{totals.percentile(1).to_i}
  10th:          #{totals.percentile(10).to_i}
  25th:          #{totals.percentile(25).to_i}
  median:        #{totals.median.to_i}
  75th:          #{totals.percentile(75).to_i}
  90th:          #{totals.percentile(90).to_i}
  99th:          #{totals.percentile(99).to_i}

  stddev:        #{totals.standard_deviation.round(1)}
  variance:      #{totals.variance.round(1)}

  avg die:       #{(totals.mean / 6).round(1)}
  avg max score: #{scores.map(&:max).mean.round(1)}
  avg min score: #{scores.map(&:min).mean.round(1)}

  chance/14:     #{(scores.map(&:max).select { |x| x >= 14}.size / scores.size.to_f * 100).round}%
  chance/16:     #{(scores.map(&:max).select { |x| x >= 16}.size / scores.size.to_f * 100).round}%
  chance/18:     #{(scores.map(&:max).select { |x| x >= 18}.size / scores.size.to_f * 100).round}%

  HEREDOC
end


puts "rolling #{ITERATIONS} iterations w/o rerolling"
scores = ITERATIONS.times.map { ability_scores }
print_output(scores)

puts "rolling #{ITERATIONS} iterations WITH REROLLING"
scores = ITERATIONS.times.map { ability_scores(70) }
print_output(scores)
