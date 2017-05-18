# Archive extraction utilities
# Part of RetroFlix

require 'tempfile'
require 'zip'

module RetroFlix
  # Extract archive if valid format is detected, else simply return
  # Currently only supports Zip files but other archive types may
  # be added
  def self.extract_archive(archive)
    f = Tempfile.new('retroflix')
    f.write archive

    begin
      zf = Zip::File.open(f.path).first
      [zf.name, zf.get_input_stream.read]
    rescue Zip::Error => e
      archive
    end
  end
end
