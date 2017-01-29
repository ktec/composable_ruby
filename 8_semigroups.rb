# A semigroup is a type with a concat method
#
# String is a semigroup
# "bat".concat("man") # => "batman"
#
# Array is a semigroup
# [1].concat([2,3]) # => [1,2,3]
#
# addition(:+) is a semigroup, however there is no `concat`
# method on an Integer
#
# Associativity means we can group in any order and the result will always
# be the same:
#
# (1 + 1) + 1 == 1 + (1 + 1)

class Box
  attr_reader :x
  def self.of(x)
    new(x)
  end
  def initialize(x)
    @x = x
  end
  def self.inherited(subclass)
    subclass.send(:define_method, :inspect) do
      "#{subclass}(#{@x})"
    end
  end
end

class Sum < Box
  def concat(y)
    Sum.of(@x + y.x)
  end
end

result = Sum.of(1).concat(Sum.of(2))

puts result.inspect

class All < Box
  def concat(y)
    All.of(@x && y.x)
  end
end

result = All.of(true).concat(All.of(true).concat(All.of(true)))

# [true,true,true]
#   .map(&All.method(:of))
#   .map(&:concat)

puts result.inspect

class First < Box
  def concat(y)
    First.of(@x)
  end
end

result =
  First.of("keith").concat(First.of("was").concat(First.of("here")))

# result = First.of("keith").concat(First.of("something else"))

puts result.inspect
