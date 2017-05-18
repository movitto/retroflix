# Emulator configuration
# Part of RetroFlix

module RetroFlix
  # Run on main display
  DISPLAY="DISPLAY=:0"

  # Configure emulators to for various systems
  EMULATORS = {
    :N64     => "",
    :NES     => "#{DISPLAY} nestopia \"GAME\"",
    :SNES    => "#{DISPLAY} zsnes \"GAME\"",
    :Genesis => "#{DISPLAY} gens \"GAME\""
  }

  # fork / execs emaulator process & detaches
  def self.play_game(system, game)
    emulator = EMULATORS[system].gsub("GAME", game_path_for(system, game))

    pid = fork{ exec emulator }
    Process.detach pid
    nil
  end
end
