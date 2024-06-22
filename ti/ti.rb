require 'csv'
require 'pp'
require 'set'

players = ARGV
faction_count = Integer(ENV["FACTIONS"] || players.size + 3)
seed = ENV["SEED"] || rand(100)
random = Random.new(Integer(seed))
game_count = 4
max_pop= (game_count - 1) * 1.5
last_game = Set.new(["Naalu Collective", "Argent Flight", "Empyrean", "Vuil’Raith Cabal"])

puts "Draft order: " + players.shuffle(random: random).join(" ")

# factions = CSV.read("factions.csv", headers: true).sort_by do |row|
#   [row["Popularity"], random.rand]
# end.take(faction_count).map do |row|
#   row["Faction"]
# end.sort

factions = CSV.read("factions.csv", headers: true).map do |row|
  row.to_h.transform_keys(&:to_sym)
end.reject { |f| last_game.include?(f[:name]) }.shuffle(random: random)

base, pok = factions.partition { |f| f[:set] != "PoK" }
available = (base.take(5) + pok.take(4)).map { |f| f[:name] }

# weight_total = 0
# weights = CSV.read("factions.csv", headers: true).map do |row|
#   next if last_game.include?(row["Name"])
#   pok = row["Set"] == "Pok" ? 1 : 0
#   weight = ((max_pop - row["Plays"].to_i) - (row["Wins"].to_f / 2) + pok) ** 2
#   weight_total += weight
#   [row["Name"], weight]
# end.compact.to_h
# pp weights
# factions = weights.to_a.shuffle(random: random).max_by(faction_count) { |_, w| random.rand ** (weight_total / w) }

puts "Available factions:\n#{available.join("\n")}\n"
