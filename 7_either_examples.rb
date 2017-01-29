require './either'

module Site
  module_function
  def show_login(no_user)
    "You must log in"
  end

  def render_page(current_user)
    "Welcome to the future #{current_user}"
  end
end

def open_site(current_user)
  from_nullable(current_user)
  .fold(
    Site.method(:show_login), # Left
    Site.method(:render_page) # Right
  )
end

puts open_site(nil)

puts open_site(:keith)

def default_prefs(_)
  { welcome: "Hi there stranger!"}
end

def load_prefs(user)
  { welcome: "Welcome back #{user.name}" }
end

def get_prefs(user)
  user.premium ? Right.new(user) : Left.new('not premium')
  .map { |u| u.preferences }
  .fold(
    message(:default_prefs),
    method(:load_prefs)
  )
end

def street_name(user)
  from_nullable(user.address)
  .chain { |a| from_nullable(a.street) }
  .chain { |s| from_nullable(s.name) }
  .fold(
    ->(e) { 'no street' },
    ->(n) { n }
  )
end

require './hash_extend'
user_with_street = { address: { street: { name: 'Buckingham Palace Road' } } }
user_with_street.extend(H)

puts street_name(user_with_street)

user = { address: nil }
user.extend(H)

puts street_name(user)

def concat_if_uniq(x, ys)
  from_nullable(ys.find { |y| y == x })
  .fold(
    ->(_) { ys.concat([x]) }, # not found so concat
    ->(_) { ys } # already exists in list
  )
end

result = concat_if_uniq(2, [1,2,3])
puts result.inspect

result = concat_if_uniq(4, [1,2,3])
puts result.inspect

def read_file(path)
  try_catch { File.open(path).read }
end

puts read_file('config.json').fold(
  ->(e) { e },
  ->(f) { f }
)

puts read_file('missing file').fold(
  ->(e) { e },
  ->(f) { f }
)

def wrap_example(example)
  from_nullable(example.previewPath)
  .chain(method(:read_file))
  .fold(
    ->(_) { example },
    ->(ex) { { preview: ex } }
  )
end

example = { previewPath: 'config.json' }
example.extend(H)

puts wrap_example(example)

require 'json'

def parse_db_url(config)
  try_catch { JSON.parse(config) }
  .chain { |c| from_nullable(c["url"]) }
  .fold(
    ->(e) { e },
    ->(u) { u =~ /postgres:\/\/([^:]+):([^@]+)@([^:]+):(\d+)\/(.+)/ }
  )
end

puts parse_db_url("{ \"url\": \"postgres://123141:user@example.com:121212/database\" }")
