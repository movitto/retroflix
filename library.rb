# Game library management routines.
# The library consists of games downloaded into the
# local games/ directory.
# Part of RetroFlix

require 'fileutils'

module RetroFlix
  GAMES_DIR = "games/"

  def self.game_dir_for(system)
    "#{GAMES_DIR}#{system}"
  end

  def self.game_path_for(system, game)
    dir = "#{game_dir_for(system)}/#{game}"
    Dir.glob("#{dir}/*").first
  end

  def self.write_game(system, game, game_file, contents)
    dir = game_dir_for(system)
    FileUtils.mkdir_p("#{dir}/#{game}/") unless File.directory?("#{dir}/#{game}/")
    File.write("#{dir}/#{game}/#{game_file}", contents)
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

  def self.delete_game(system, game)
    FileUtils.rm_rf("#{game_dir_for(system)}/#{game}")
  end
end
