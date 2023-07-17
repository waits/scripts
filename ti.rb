seed = ARGV[0]
players = ARGV[1..-1]
srand(Integer(seed))

puts "Draft order: " + players.shuffle.join(" ")

if ENV["RACES"]
  race_count = players.length + 3
  races = File.read("ti_races.txt").split("\n\n").map do |race|
    race.split("\n").first
  end.shuffle.take(race_count)
  puts "Available factions:\n"
  puts races.join("\n")
end
