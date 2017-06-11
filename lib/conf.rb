# Config
# Part of RetroFlix

require_relative './deep_struct'
require 'yaml'

module RetroFlix
  CONFIG_FILES = [File.expand_path('~/.retroflix.yml'),
                  File.expand_path('../../retroflix.yml', __FILE__)]

  unless CONFIG_FILES.any? { |cf| File.exists?(cf) }
    raise RuntimeError, "cannot find config at #{CONFIG_FILES.join(", ")}"
  end

  CONFIG_FILES.each { |cf|
    Config = DeepStruct.new(YAML.load_file(cf)) if File.exists?(cf) && !defined?(Config)
  }
end
