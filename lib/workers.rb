# Background job workers
# Part of RetroFlix

require 'workers'

RFPool = Workers::Pool.new

module RetroFlix
  def self.background_job(&bl)
    RFPool.perform &bl
  end
end # module RetroFlix

at_exit do
  # 3 seconds to cleanup
  RFPool.dispose(3)
end
