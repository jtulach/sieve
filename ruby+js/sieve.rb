class Natural
  def initialize
    @x = 2
  end

  def next
    return @x += 1
  end
end

def create
  Natural.new
end

Truffle::Interop.export("Natural", method(:create));