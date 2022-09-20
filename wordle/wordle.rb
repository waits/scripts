require 'benchmark'
require 'csv'
require 'set'

# @answers = CSV.read("answers.csv").flatten

@iterations = ARGV[0].to_i
@answers_only = ARGV.include?("--answers-only") || ARGV.include?("-a")
@words = CSV.read("words.csv", headers: true).map do |row|
  yellow = row["yellow"].split(" ").map { |s| a = s.split(":"); [a[0], a[1].to_i] }.to_h
  green = row["green"].split(" ").map(&:to_i)
  {
    word: row["word"],
    answer: row["answer"] == "true",
    chars: Set.new(row["word"].chars.sort),
    green: green,
    yellow: yellow,
    score: green.sum + yellow.values.sum,
  }
end.sort_by { |word| -word[:score] }.map.with_index { |word, i| word.merge(index: i) }
@chars = CSV.read("chars.csv", headers: true).map do |row|
  [row["char"], {pos: row["pos"].split(" ").map(&:to_i), sum: row["sum"].to_i}]
end.to_h

def find_best_word(without_chars, start_at, answers_only)
  best = @words[start_at..-1].find.with_index do |w, i|
    next if answers_only && !w[:answer]
    (w[:chars] & without_chars).size < (without_chars.size > 10 ? 2 : 1)
  end
end

result = @iterations.times.reduce({words: [], chars: Set.new, upto: 0, score: 0}) do |h, i|
  word = find_best_word(h[:chars], h[:upto], @answers_only)
  puts "#{word[:word]} #{word[:score]}"
  h[:words] << word[:word]
  h[:chars] += word[:chars]
  h[:upto] = word[:index]
  h[:score] += word[:score]
  h
end

puts result[:score]

# words.take(1).each.with_index do |first_word, i1|
#   w3 = words[i1..-1].find.with_index do |w3, i3|
#     w3[:chars].disjoint?(w1[:chars]) && w3[:chars].disjoint?(w2[:chars])
#   end
# end

# CSV.open("words.csv", "w") do |csv|
#   csv << ["word", "answer", "green", "yellow"]
#   words.each do |word|
#     green, yellow, best = [], {}, ""
#     word[:word].chars.each.with_index do |c, i|
#       green << chars[c][:pos][i]
#       yellow[c] = chars[c][:sum]
#     end
#     csv << [
#       word[:word],
#       answers.include?(word[:word]),
#       green.join(" "),
#       yellow.to_a.sort.map { |y| y.join(":") }.join(" "),
#     ]
#   end
# end

# char_freq = answers.each_with_object({}) do |word, hash|
#   word.chars.each_with_index do |c, i|
#     hash[c] ||= Array.new(5, 0)
#     hash[c][i] += 1
#   end
# end.sort_by { |char, freq| -char }

# CSV.open("chars.csv", "w", headers: true, quote_char: "") do |csv|
#   csv << ["char", "pos", "sum"]
#   char_freq.each do |char, freq|
#     csv << [char, freq.join(" "), freq.sum]
#   end
# end

# combined_scores = guess_scores.take(100).flat_map do |word, score|
#   guess_scores.take(500).flat_map do |word2, score2|
#     next unless (word.chars & word2.chars).empty?
#     guess_scores.map do |word3, score3|
#       next unless (word.chars | word2.chars | word3.chars).length == 15
#       [word, word2, word3, score + score2 + score3]
#     end.compact
#   end.compact
# end.sort_by { |word, word2, word3, score| -score }
