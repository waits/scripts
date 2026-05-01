#!/usr/bin/env ruby
# monster_scrape.rb
#
# Downloads the Gloomhaven monster spoilers page from Cephalofair and scrapes
# monster names + standee counts into a CSV file.
#
# Usage:
#   ruby monster_scrape.rb [output.csv]
#
# Dependencies:
#   gem install nokogiri   (html parsing)
#
# The CSV is written to "monsters.csv" by default, or to the path given as the
# first command-line argument.

require "net/http"
require "uri"
require "csv"
require "nokogiri"

URL        = "https://cephalofair.com/pages/gloomhaven-monster-spoilers"
OUTPUT_CSV = ARGV.fetch(0, File.join(__dir__, "monsters.csv"))

# ---------------------------------------------------------------------------
# Fetch the page
# ---------------------------------------------------------------------------
puts "Fetching #{URL} ..."

uri      = URI.parse(URL)
response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
  http.get(uri.request_uri, "User-Agent" => "Ruby/monster_scrape")
end

unless response.is_a?(Net::HTTPSuccess)
  abort "HTTP error: #{response.code} #{response.message}"
end

# ---------------------------------------------------------------------------
# Parse the HTML
# ---------------------------------------------------------------------------
doc = Nokogiri::HTML(response.body)

# The page marks each entry in a <strong> tag with the format:
#   Monster Name (count)
# We grab every <strong> element and keep only those matching the pattern.
MONSTER_RE = /\A(.+?)\s*\((\d+)\)\z/

monsters = doc.css("strong").map do |node|
  text = node.text.strip
  m    = MONSTER_RE.match(text)
  next unless m

  { monster: m[1].strip, count: m[2].to_i }
end.compact

if monsters.empty?
  abort "No monsters found — the page structure may have changed."
end

# ---------------------------------------------------------------------------
# Write CSV
# ---------------------------------------------------------------------------
CSV.open(OUTPUT_CSV, "w", headers: %w[monster count], write_headers: true) do |csv|
  monsters.each { |row| csv << [row[:monster], row[:count]] }
end

puts "Wrote #{monsters.size} monsters to #{OUTPUT_CSV}"
