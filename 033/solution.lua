local helpers = loadfile("helpers.lua")()
local lib = loadfile("library.lua")()

-- Recycled from solution 21
-- More metatable fun to make the tests more readable
local array_mt = {}

function array(input) 
  setmetatable(input, array_mt)
  return input
end

array_mt.__eq = function (lhs, rhs)
  if #lhs ~= #rhs then
    return false
  end

  for i=1, #lhs do
    if lhs[i] ~= rhs[i] then
      return false
    end
  end
  return true
end

-- Return the digits from a number as an `array`
function digitsFrom(number)
  if number < 0 then return nil end
  local numberString = string.format("%d", number)
  local digits = array{}
  for i=1, #numberString do
    digits[i] = tonumber(string.sub(numberString, i, i))
  end
  return digits
end

helpers.testGroup {
  "digitsFrom",
  tests = {
    {array{4}, digitsFrom, 4},
    {array{4, 9}, digitsFrom, 49},
  }
}

-- Boolean test if a number is a curious fraction
function isCuriousFraction(numerator, denominator)
  -- bounds checks
  if numerator < 10 or numerator > 99
    or denominator < 10 or denominator > 99
    or numerator > denominator then
      return false
  end

  -- triviality check
  if numerator % 10 == 0 and denominator % 10 == 0 then
    return false
  end

  local value = numerator / denominator
  local numeratorDigits = digitsFrom(numerator)
  local denominatorDigits = digitsFrom(denominator)

  local foundDigitInCommon = false

  local index = 1
  while index <= #numeratorDigits do
    local digit = numeratorDigits[index]
    local denominatorIndex = nil

    for i=1, #denominatorDigits do
      if denominatorDigits[i] == digit then
        denominatorIndex = i
        foundDigitInCommon = true
      end
    end

    if denominatorIndex then
      -- Since we're removing this index, we don't need to increment it.
      table.remove(numeratorDigits, index)
      table.remove(denominatorDigits, denominatorIndex)
    else
      index = index + 1
    end
  end

  if #numeratorDigits == 0 or #denominatorDigits == 0 then
    return false
  end

  local reducedValue = tonumber(table.concat(numeratorDigits)) / tonumber(table.concat(denominatorDigits))

  return foundDigitInCommon and reducedValue == value
end

helpers.testGroup {
  "isCuriousFraction",
  tests = {
    {true, isCuriousFraction, 49, 98},
    -- This is digit-reducable, but it's trivial
    {false, isCuriousFraction, 30, 50},
    -- These don't have any digits in common
    {false, isCuriousFraction, 12, 34},
    -- All fractions must be less than one
    {false, isCuriousFraction, 98, 49},
    -- Numerator must be 2 digits
    {false, isCuriousFraction, 5, 50},
    -- Denominator must be 2 digits
    {false, isCuriousFraction, 50, 5}
  }
}

function findTheFour()
  local curiousFractions = array{}
  for x=10, 99 do
    for y=x+1, 99 do
      if isCuriousFraction(x, y) then
        curiousFractions[#curiousFractions + 1] = {numerator = x, denominator = y}
      end
    end
  end
  return curiousFractions
end

function solve()
  local fractions = findTheFour()
  local numerator = 1
  local denominator = 1
  for i=1, #fractions do
    local fraction = fractions[i]
    numerator = numerator * fraction.numerator
    denominator = denominator * fraction.denominator
  end

  for i=2, numerator do
    while numerator % i == 0 and denominator % i == 0 do
      numerator = numerator / i
      denominator = denominator / i
    end
  end

  return denominator
end

helpers.benchmark(solve)