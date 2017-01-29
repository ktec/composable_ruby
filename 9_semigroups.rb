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

class All < Box
  def concat(y)
    All.of(@x && y.x)
  end
end

class First < Box
  def concat(y)
    First.of(@x)
  end
end

class Map < Hash
  def concat
    # do something here?
  end
end

acct1 = { name: "Nico", is_paid: true, points: 10, friends: ['Franklin'] }
acct2 = { name: "Nico", is_paid: false, points: 2, friends: ['Gatsby'] }

# Ruby's Hash merge will fail to merge correctly:
# acct1.merge(acct2)
# => {:name=>"Nico", :is_paid=>false, :points=>2, :friends=>["Gatsby"]}

# Sure we could do a block:
# acct1.merge(acct2) do |key, oldv, newv|
#   case key
#   when :name
#     ...
#   end
# end

# But.....ug, no that's not nice...

# One law about semigroups, if all the elements are semigroups, the whole thing
# is also a semigroup!

# Lets try again...

module HashConcat
  def concat(other)
    each_with_object({}) do |(k, v), h|
      h[k] = v.concat(other[k])
    end
  end
end

acct1 = { name: First.of("Nico"), is_paid: All.of(true), points: Sum.of(10), friends: ['Franklin'] }
acct2 = { name: First.of("Nico"), is_paid: All.of(false), points: Sum.of(2), friends: ['Gatsby'] }

acct1.extend(HashConcat)
acct2.extend(HashConcat)


puts acct1.concat(acct2)
