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

Polyglot.export("Natural", method(:create));
