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
    score: green.sum + yellow.values.sum,
  }
end.select { |w| w[:answer] }.sort_by { |word| -word[:score] }.map.with_index { |word, i| word.merge(index: i) }.freeze

def next_guess(green, yellow, gray, attempts)
  guesses = valid_words(green, yellow, gray, true)
  raise "no words found" if guesses.empty?
  guess = best_guess(guesses)
  [guess[:word], guess[:answer], guesses.size]
end

def best_guess(guesses)
  loops = if guesses.size > 500 then 25 else 100 end
  guesses.take(loops).sort_by do |g|
    guess_score(g[:word], guesses)
  end.first
end

def guess_score(word, answers)
  answers_left = 0
  answers.each do |answer|
    a = answer[:word]
    hint = word.chars.map.with_index do |c, i|
      case
      when c == a[i] then "g"
      when a.chars.include?(c) then "y"
      else "-"
      end
    end.join("")
    green, yellow, gray = parse_hint(hint, word)
    answers_left += valid_words(green, yellow, gray, true, answers).size
  end
  puts "#{word} = #{answers_left}"
  answers_left
end

def valid_words(green, yellow, gray, answers_only, word_list=WORDS)
  word_list.select do |w|

    next if green && green.each_char.with_index.any? { |g, i| g != "-" && g != w[:word][i] }
    next if yellow && yellow.each_char.with_index.any? do |y, i|
      y != "-" && (y == w[:word][i] || !w[:word].include?(y))
    end
    (w[:chars] & gray).empty?
  end
end

def parse_hint(s, word)
  green, yellow, gray = "-----", "-----", Set.new
  s.each_char.with_index do |hint, i|
    case hint
    when "g" then green[i] = word[i]
    when "y" then yellow[i] = word[i]
    else gray << word[i]
    end
  end
  [green, yellow, gray]
end

green, yellow, gray = "-----", "-----", Set.new
attempts = 0
word = "raise (2316) A"
# word, answer, remaining = next_guess(green, yellow, gray, attempts)
loop do
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
  
  word, answer, remaining = next_guess(green, yellow, gray, attempts)
  word += " (#{remaining})"
  word += " A" if answer
end