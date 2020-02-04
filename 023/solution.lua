local helpers = loadfile("helpers.lua")()

-- Test a group of inputs & outputs. 
function testGroup(input)
  local title = string.format("\nTesting %s...", input.title or "")
  print(title)
  for i=1, #(input.tests or {}) do
    helpers.expect(table.unpack(input.tests[i]))
  end
end

-- Use slow O(n) approach from my memory
divisorsMemo = {}
function divisorsFor(number)
  if divisorsMemo[number] ~= nil then return divisorsMemo[number] end
  local result = {}
  for i=1, number/2 + 1 do
    if number % i == 0 then
      result[#result + 1] = i
    end
  end
  divisorsMemo[number] = result
  return result
end

-- Return true if a number is abundant
abundantMemo = {}
function isAbundant(number) 
  if abundantMemo[number] ~= nil then return abundantMemo[number] end
  local divisors = divisorsFor(number)
  local sum = 0
  for i=1, #divisors do
    sum = sum + divisors[i]
  end
  local result = sum > number
  abundantMemo[number] = result
  return result
end

-- return true if a number is the sum of two abundant numbers. 
function isSumOfTwoAbundantNumbers(number)
  for i=1, number / 2 + 1 do
    local biggerHalf = number - i
    if isAbundant(i) and isAbundant(biggerHalf) then
      return true
    end
  end
  return false
end

-- This is a terrible name, but suits the problem
function sumOfNotAbundantSumNumbers()
  local abundantSumsAreAllAtOrAbove = 28123
  local sum = 0
  for i=1, abundantSumsAreAllAtOrAbove - 1 do
    if not isSumOfTwoAbundantNumbers(i) then
      sum = sum + i
    end

    if i % 1000 == 0 then
      helpers.ping(i .. " of " .. abundantSumsAreAllAtOrAbove)
    end
  end
  return sum
end

-- Fast pasters
-- Summing all pairs in {a b c d}
--    becomes (a + b) + (a + c) + (a + d) + (b + c) + (b + d) + (c + d)
--    becomes 3a + 3b + 3c + 3d
--    becomes 3 (a + b + c + d)
--    becomes (n-1) * (a + b + ... + n) 
function sumOfAllPairs(pairList)
  local sum = 0
  for i = 1, #pairList do
    sum = sum + pairList[i]
  end
  return sum * (#pairList - 1)
end

testGroup{
  title = "isAbundant",
  tests = {
    {false, isAbundant, 28},
    {true, isAbundant, 12}
  }
}

testGroup{
  title = "sumOfAllPairs",
  tests = {
    {12, sumOfAllPairs, {1, 2, 3}}
  }
}

-- helpers.expect(false, isAbundant, 28)
-- helpers.expect(true, isAbundant, 12)

helpers.benchmark(sumOfNotAbundantSumNumbers)