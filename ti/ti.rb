require 'csv'
require 'pp'
require 'set'

players = ARGV
faction_count = Integer(ENV["FACTIONS"] || players.size + 3)
seed = ENV["SEED"] || rand(100)
random = Random.new(Integer(seed))
excluded_factions = Set.new([
"Empyrean",
"Naalu Collective",
"Embers of Muaat",
"Universities of Jol-Nar",
"Xxcha Kingdom",
"Yin Brotherhood",
"Mentak Coalition",
"Emirates of Hacan",
"Council Keleres",
])

puts "Draft order: " + players.shuffle(random: random).join(" ")

factions = CSV.read("factions.csv", headers: true).map do |row|
  row.to_h.transform_keys(&:to_sym)
end.reject { |f| excluded_factions.include?(f[:name]) }

available = factions
  .shuffle(random: random)
  .take(faction_count)
  .map { |f| f[:name] }.sort

puts "Available factions:\n#{available.join("\n")}\n"
