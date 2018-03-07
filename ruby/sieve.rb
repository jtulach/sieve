class Natural
  def initialize
    @x = 1
  end

  def next
    @x += 1
  end
end

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

class Primes
  def initialize(natural)
    @natural = natural
    @filter = nil
  end

  def next
    while true
      n = @natural.next
      if @filter == nil
        @filter = Filter.new(n)
        return n
      end
      if @filter.acceptAndAdd(n)
        return n
      end
    end
  end
end

def ms(start)
  ((Time.now - start) * 1000).floor
end

def fewthousands
  natural = Natural.new
  primes = Primes.new(natural)

  start = Time.now
  cnt = 0
  prntCnt = 97
  begin
    res = primes.next
    cnt += 1
    if cnt % prntCnt == 0
      puts "Computed #{cnt} primes in #{ms(start)} ms. Last one is #{res}."
      prntCnt = prntCnt * 2
    end
  end while cnt < 100000
  ms(start)
end

puts "Ready!"

count = -1
if ARGV.length == 1
then
  count = ARGV[0].to_i
end

while count != 0
  puts "Hundred thousand prime numbers in #{fewthousands} ms"
  count = count - 1
end
