class Natural
  def initialize
    @x = 1
  end

  def next
    @x += 1
  end
end

def create
  Natural.new
end

Truffle::Interop.export("Natural", method(:create));