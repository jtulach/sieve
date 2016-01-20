class Natural
  def initialize
    @x = 2
  end

  def next
    @x += 1
  end
end

class Filter
  attr_reader :number, :filter

  def initialize(number, filter)
    @number = number
    @filter = filter
  end

  def accept(n)
    filter = self
    while filter
      if n % filter.number == 0
        return false
      end
      filter = filter.filter
    end
    true
  end
end

class Primes
  def initialize(natural)
    @natural = natural
    @filter = nil
  end

  def next
    while true
      n = @natural.next
      if @filter == nil || @filter.accept(n)
        @filter = Filter.new(n, @filter)
        return n
      end
    end
  end
end

def fewthousands
  natural = Natural.new
  primes = Primes.new(natural)

  start = Time.now
  cnt = 0
  begin
    res = primes.next
    cnt += 1
    if cnt % 1000 == 0
      puts "Computed #{cnt} primes in #{Time.now - start} s. Last one is #{res}."
    end
  end while cnt < 5000
  Time.now - start
end

puts "Ready!"
loop do
  puts "Five thousand prime numbers in #{fewthousands} s"
end
