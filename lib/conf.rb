# Config
# Part of RetroFlix

require_relative './deep_struct'
require 'yaml'

module RetroFlix
  CONFIG_FILE = './retroflix.yml'

  Config = DeepStruct.new(YAML.load_file(CONFIG_FILE))
end
