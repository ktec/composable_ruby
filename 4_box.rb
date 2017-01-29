require './box'

def money_to_float(str)
  Box.new(str)
  .map { |s| s.gsub(/\$/, '') }
  .map { |r| r.to_i }
end

def percent_to_float(str)
  Box.new(str.gsub(/\%/, ''))
  .map { |s| s.to_i }
  .map { |x| x * 0.01 }
end

def apply_discount(price, discount)
  money_to_float(price)
  .fold { |cost|
    percent_to_float(discount)
    .fold { |savings| cost - cost * savings }
  }
end

# result = money_to_float('$10')
# result = percent_to_float('10%')
result = apply_discount('$5.00', '20%')

puts result
