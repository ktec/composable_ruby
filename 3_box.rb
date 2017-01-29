require './box'

def next_char_for_number_string(str)
  Box.new(str)
  .map { |s| s.lstrip }
  .map { |s| s.rstrip }
  .map { |r| r.to_i }
  .map { |i| i + 1 }
  .map { |i| i.chr }
  .fold { |c| c.downcase }
end

result = next_char_for_number_string(' 64 ')
puts result
