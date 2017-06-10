# Emulator configuration
# Part of RetroFlix

module RetroFlix
  # Run on main display
  DISPLAY="DISPLAY=:0"

  # Return configured emulator for system
  def self.emulator_for(system)
    emulator = Config.emulators.send(system)
    "#{Config.emulators.env} #{emulator.bin} #{emulator.flags}"
  end


  # fork / execs emaulator process & detaches
  def self.play_game(system, game)
    emulator = emulator_for(system).gsub("GAME", game_path_for(system, game))

    pid = fork{ exec emulator }
    Process.detach pid
    nil
  end
end
