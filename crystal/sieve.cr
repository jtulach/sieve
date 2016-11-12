class Natural
  @cnt = 1

  def next
    @cnt += 1
  end
end

class Filter
  getter number
  property! next : Filter
  property! last : Filter

  def initialize(@number : Int32)
    @last = self
  end

  def accept_and_add(n)
    filter = self
    upto = Math.sqrt(n)
    loop do
      if n.divisible_by?(filter.number)
        return false
      end
      if filter.number > upto
        new_filter = Filter.new(n)
        last.next = new_filter
        @last = new_filter
        return true
      end
      filter = filter.next
    end
  end
end

class Primes
  @natural = Natural.new

  def next
    loop do
      n = @natural.next
      filter = @filter
      unless filter
        @filter = Filter.new(n)
        return n
      end
      if filter.accept_and_add(n)
        return n
      end
    end
  end

  def compute
    start = Time.now
    cnt = 0
    prnt_cnt = 97
    res = 0
    loop do
      res = self.next
      cnt += 1

      if cnt.divisible_by?(prnt_cnt)
        took = Time.now - start
        puts "Computed #{cnt} primes in #{took.milliseconds} ms. Last one is #{res}"
        prnt_cnt *= 2
      end
      break if cnt >= 100000
    end
    res
  end
end

loop do
  p = Primes.new
  time = Time.now
  p.compute
  took = Time.now - time
  puts "Hundred thousand primes computed in #{took.milliseconds}ms"
end
