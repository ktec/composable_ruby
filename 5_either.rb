require './either'

def find_color(name)
  from_nullable(
    {red: '#ff444', blue: '#3b5998', yellow: '#fff68f'}[name.to_sym]
  )
end

success = find_color('red')
          .map { |c| c.slice(1..99) }
          .fold(->(e){ 'no color' },
                ->(c){ c.upcase() })

puts success

failure = find_color('this does not exist')
          .map { |c| c.slice(1..99) }
          .fold(->(e){ 'no color' },
                ->(c){ c.upcase() })

puts failure
