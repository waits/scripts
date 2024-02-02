require 'csv'

players = ARGV
faction_count = Integer(ENV["FACTIONS"] || players.size + 3)
seed = ENV["SEED"] || 0
random = Random.new(Integer(seed))

puts "Draft order: " + players.shuffle(random: random).join(" ")

factions = CSV.read("factions.csv", headers: true).sort_by do |row|
  [row["Popularity"], random.rand]
end.take(faction_count).map do |row|
  row["Faction"]
end.sort
puts "Available factions:\n#{factions.join("\n")}\n"
