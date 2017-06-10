# Helper script to download random game
# Part of RetroFlix

require_relative './lib/conf'
require_relative './lib/scrape'
require_relative './lib/library'

system  = RetroFlix::systems.sample

games   = RetroFlix.games_for(system)
game    = games.to_a.sample
name    = game[0]
url     = game[1]

page    = RetroFlix.game_page_for(system, game)
screens = RetroFlix.screens_for(page)
desc    = RetroFlix.desc_for(page)

RetroFlix.write_game(system, name, name, RetroFlix.download(system, name))

puts "Downloaded #{name} for #{system}"
