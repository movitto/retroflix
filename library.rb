# Game library management routines.
# The library consists of games downloaded into the
# local games/ directory.
# Part of RetroFlix

require 'fileutils'

module RetroFlix
  GAMES_DIR = "games/"

  def self.game_dir_for(system)
    "#{GAMES_DIR}/#{system}"
  end

  def self.game_path_for(system, game)
    "#{game_dir_for(system)}/#{game}"
  end

  def self.write_game(system, game, contents)
    dir = game_dir_for(system)
    FileUtils.mkdir_p(dir) unless File.directory?(dir)
    File.write("#{dir}/#{game}", contents)
  end

  def self.library_games_for(systems)
    return library_games_for([systems]) unless systems.is_a?(Array)
    systems.collect { |sys|
      dir = "#{game_dir_for(sys)}/"
      Dir.glob("#{dir}*").collect { |g| g.gsub(dir, "") }
    }.flatten
  end

  def self.have_game?(system, game)
    library_games_for(system).include?(game)
  end
end
