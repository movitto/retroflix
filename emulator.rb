# Emulator configuration
# Part of RetroFlix

module RetroFlix
  # Configure emulators to for various systems
  EMULATORS = {
    :N64     => "",
    :NES     => "nestopia \"GAME\"",
    :SNES    => "zsnes \"GAME\"",
    :Genesis => "gens \"GAME\""
  }

  # fork / execs emaulator process & detaches
  def self.play_game(system, game)
    emulator = EMULATORS[system].gsub("GAME", game_path_for(system, game))

    pid = fork{ exec emulator }
    Process.detach pid
    nil
  end
end
