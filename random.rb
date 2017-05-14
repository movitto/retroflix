# Helper script to download random game
# Part of RetroFlix

require_relative './scrape'
require_relative './library'

system  = RetroFlix::SYSTEMS.keys.sample

games   = RetroFlix.games_for(system)
game    = games.to_a.sample
name    = game[0]
url     = game[1]

page    = RetroFlix.game_page_for(url)
screens = RetroFlix.screens_for(page)
desc    = RetroFlix.desc_for(page)

dl_link = RetroFlix.download_link_for(url)
RetroFlix.write_game(system, name, RetroFlix.download(system, name, dl_link))

puts "Downloaded #{name} for #{system}"
