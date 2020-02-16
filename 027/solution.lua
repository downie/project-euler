local helpers = loadfile("helpers.lua")()
local lib = loadfile("library.lua")()

-- Prime test by trial division
prime_memo = {}
function isPrime(n)
  if prime_memo[n] ~= nil then
    return prime_memo[n]
  end
  for i=2, math.ceil(n ^ 0.5) do
    if n % i == 0 then
      prime_memo[n] = false
      return false
    end
  end
  prime_memo[n] = true
  return true
end


-- Return a quadratic function to test primes in
function formula(a, b)
  return function(n)
    return (n * n) + (a * n) + b
  end
end

helpers.testGroup {
  "formula",
  tests = {
    {41, formula(1, 41), 0},
    {43, formula(1, 41), 1}
  }
}

-- Return the number of consecutive primes generated by the form n^2 + an + b for n >= 0
function primeCount(a, b, maxN)
  maxN = maxN or math.huge
  local quadraticFor = formula(a, b)
  local count = 0
  for n = 0, maxN do
    local result = quadraticFor(n)
    if isPrime(result) then
      count = count + 1
    else
      return count
    end
  end
  -- This shouldn't happen, as I expect the loop to fail before math.huge
  print("reached maxN" .. maxN)
  return count
end

helpers.testGroup {
  "primeCounts",
  tests = {
    {40, primeCount, 1, 41},
    {80, primeCount, -79, 1601}
  }
}

function coefficientsWithMostConsecutivePrimes(aRange, bRange)
  local mostPrimes = -1
  local mostPrimesAValue
  local mostPrimesBValue
  for a=-aRange, aRange do
    for b=-bRange, bRange do
      local primes = primeCount(a, b)
      if primes > mostPrimes then
        print(string.format("a=%d, b=%d has %d primes", a, b, primes))
        mostPrimes = primes
        mostPrimesAValue = a
        mostPrimesBValue = b
      end
    end
    if a % 100 == 0 then
      helpers.ping(string.format("a is %d", a))
    end
  end

  return mostPrimesAValue, mostPrimesBValue
end

function solve(maxA, maxB)
  local a, b = coefficientsWithMostConsecutivePrimes(maxA, maxB)
  print("coefficients are:", a, b)
  return a * b
end

-- helpers.testGroup {
--   "solve",
--   tests = {
--     {41, solve, 1, 41},
--   }
-- }

helpers.benchmark(solve, 1000 - 1, 1000)