class Filter
  attr_reader :number
  attr_accessor :next

  def initialize(number)
    @number = number
    @next = nil
    @last = self
  end

  def acceptAndAdd(n)
    filter = self
    upto = Math.sqrt(n)
    while filter
      if n % filter.number == 0
        return false
      end
      if filter.number > upto
        break
      end
      filter = filter.next
    end
    filter = Filter.new(n)
    @last.next = filter
    @last = filter
    true
  end
end

def create(n)
  return Filter.new(n)
end

Polyglot.export("Filter", method(:create));
