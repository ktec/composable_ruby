class Box
  def initialize(x)
    @x = x
  end

  def map(&f)
    Box.new(f.(@x))
  end

  def fold(&f)
    f.(@x)
  end

  def inspect()
    "Box(#{@x})"
  end
end

# box = ->(x) {
#   map: ->(f) {}
# }
