require 'csv'
require 'set'

WORDS = CSV.read("words.csv", headers: true).map do |row|
  yellow = row["yellow"].split(" ").map { |s| a = s.split(":"); [a[0], a[1].to_i] }.to_h
  green = row["green"].split(" ").map(&:to_i)
  {
    word: row["word"],
    answer: row["answer"] == "true",
    chars: Set.new(row["word"].chars.sort),
    green: green,
    yellow: yellow,
    score: green.sum + yellow.values.sum * (row["answer"] == "true" ? 1.1 : 1),
  }
end.sort_by { |word| -word[:score] }.map.with_index { |word, i| word.merge(index: i) }.freeze

def next_guess(green, yellow, gray, attempts)
  words = valid_words(green, yellow, gray, true)
  remaining_answers = words.length
  if words.length > 6 - attempts || words.empty?
    words = valid_words(green, yellow, gray, false)
  end
  raise "no words found" if words.empty?
  [words[0][:word], words[0][:answer], remaining_answers]
end

def valid_words(green, yellow, gray, answers_only)
  WORDS.select do |w|
    next if answers_only && !w[:answer]
    next if green && green.each_char.with_index.any? { |g, i| g != "-" && g != w[:word][i] }
    next if yellow && yellow.each_char.with_index.any? do |y, i|
      y != "-" && (y == w[:word][i] || !w[:word].include?(y))
    end
    (w[:chars] & gray).empty?
  end
end

green, yellow, gray = "-----", "-----", Set.new
attempts = 0
loop do
  word, answer, remaining = next_guess(green, yellow, gray, attempts)
  word += " (#{remaining})"
  word += " A" if answer

  puts "> " + word
  print "? "
  hints = gets.strip
  break if hints == ""

  hints.each_char.with_index do |hint, i|
    case hint
    when "g" then green[i] = word[i]
    when "y" then yellow[i] = word[i]
    else gray << word[i]
    end
  end
end