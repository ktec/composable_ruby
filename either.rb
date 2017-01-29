class Right
  def initialize(x)
    @x = x
  end

  def chain(f = nil, &block)
    if block_given?
      block.(@x)
    else
      f.(@x)
    end
  end

  def map(&f)
    Right.new(f.(@x))
  end

  def fold(f, g)
    g.(@x)
  end

  def inspect()
    "Right(#{x})"
  end
end

class Left
  def initialize(x)
    @x = x
  end

  def chain(f = nil, &block)
    Left.new(@x)
  end

  def map(&f)
    Left.new(@x)
  end

  def fold(f, g)
    f.(@x)
  end

  def inspect()
    "Left(#{x})"
  end
end

def from_nullable(x)
  x.nil? ? Left.new(nil) : Right.new(x)
end

def try_catch(&f)
  begin
    Right.new(f.())
  rescue Exception => e
    Left.new(e)
  end
end
