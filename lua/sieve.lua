#!/usr/bin/env luajit

local clock = os.clock
local log = io.write  -- this is faster than print() on LuaJIT
local sqrt = math.sqrt


--- Returns CPU time in miliseconds.
--
-- NOTE: LuaJIT cannot optimize os.clock function. Maybe we can achieve
-- better performance with some FFI based implementation of timer.
local function cpu_time ()
  return clock() * 1000  -- to ms
end


local function naturals_gen (_, i)
  return (i or 1) + 1
end

--- Returns an iterator that generates natural numbers starting with `init`.
local function naturals (init)
  return naturals_gen, nil, init
end


local LinkedList = {}
LinkedList.__index = LinkedList

--- Creates a new linked list.
function LinkedList.new ()
  return setmetatable({}, LinkedList)
end

--- Inserts the given `value` to the end of the list.
function LinkedList:push (value)
  local node = { value = value }

  if self.last then
    self.last.next = node
  else
    self.first = node
  end

  self.last = node
end

local function list_iter_gen (list, node)
  if node then
    node = node.next
  else
    node = list.first
  end

  return node, node.value
end

--- Returns an iterator that iterates over nodes of the list.
function LinkedList:iter ()
  return list_iter_gen, self, nil
end


--- Returns true if the given `num` is a prime number.
--
-- @tparam int num The number to test.
-- @tparam table found_primes Linked list of the already found primes.
local function is_prime (num, found_primes)
  local num_sqrt = sqrt(num)

  for _, prime in found_primes:iter() do
    if num % prime == 0 then
      return false
    end
    if prime > num_sqrt then
      return true
    end
  end

  return true
end

--- Returns next prime number.
--
-- @tparam table found_primes Linked list of the already found primes.
-- @tparam int|nil last_prime
local function find_primes_gen (found_primes, last_prime)
  for n in naturals(last_prime) do
    if last_prime == nil or is_prime(n, found_primes) then
      found_primes:push(n)
      return n
    end
  end
end

--- Returns an iterator that generates prime numbers.
local function find_primes ()
  return find_primes_gen, LinkedList.new(), nil
end


local function measure (print_cnt, upto)
  local cnt = 1
  local start_time = cpu_time()

  for prime in find_primes() do
    cnt = cnt + 1

    if cnt % print_cnt == 0 then
      log('Computed ', cnt, ' primes in ', cpu_time() - start_time,
          ' ms. Last one is ', prime, '\n')
      print_cnt = print_cnt * 2
    end

    if cnt >= upto then
      return cpu_time() - start_time
    end
  end
end


while true do
  local duration = measure(97, 100000)
  log('Hundred thousand prime numbers in ', duration, ' ms\n----\n')
end
