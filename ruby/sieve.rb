class Natural
  def initialize
    @x = 2
  end

  def next
    return @x += 1
  end
end

class Filter
  def initialize(number, filter)
    @number = number
    @filter = filter
  end

  def number
    @number
  end

  def filter
    @filter
  end

  def accept(n)
    filter = self
    loop do
      if (n % filter.number) == 0
        return false
      end
      filter = filter.filter;
      break if filter == nil
    end
    return true;
  end
end

class Primes
  def initialize(natural)
    @natural = natural
    @filter = nil;
  end

  def next
    loop do
      n = @natural.next
      if (@filter == nil || @filter.accept(n))
        @filter = Filter.new(n, @filter)
        return n;
      end
    end
  end
end

def fewthousands
    natural = Natural.new
    primes = Primes.new(natural)

    start = Time.now
    cnt = 0
    res = -1
    loop do
      res = primes.next
      cnt += 1
      if cnt % 1000 == 0
        puts "Computed #{cnt} primes in #{Time.now - start} s. Last one is #{res}."
        res = ""
      end
      if cnt >= 5000
        break
      end
    end
    Time.now - start
end

puts "Ready!"
loop do
  puts "Five thousand prime numbers in #{fewthousands} ms"
end


