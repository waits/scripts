require 'securerandom'

players = ARGV.shuffle(random: SecureRandom)
race_count = players.length + 3
races = File.read("ti_races.txt").split("\n\n").map(&:strip).shuffle(random: SecureRandom).take(race_count)

puts "Draft order: " + players.join(" ")
puts "\nAvailable factions:\n\n"
puts races.join("\n\n")
