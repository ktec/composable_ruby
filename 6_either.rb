require './either'
require 'json'

def get_port
  try_catch { File.open('config.json') }
  .chain { |f| try_catch { f.read } }
  .chain { |f| try_catch { JSON.parse(f) } }
  .fold(
    ->(e) { "#{e} 3000" },
    ->(c) { c['port'] }
  )
end

result = get_port()

puts result
