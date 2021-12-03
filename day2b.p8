pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
#include input2.lua
#include advent.p8

-- example
-- forward 5
-- down 5
-- forward 8

function journey(steps)
 local x = 0
 local depth = 0
 local px = 0
 local pdepth = 0
 local aim = 0
 cls(1)
 
 for step in all(steps) do
  parts = split(step, " ")
  command = parts[1]
  num = tonum(parts[2])
  if command == "forward" then
   x += num
   depth += aim * num * 0x0.0001
  elseif command == "down" then
   aim += num
  elseif command == "up" then
   aim -= num
  elseif command != "" then
   assert(false, "weird command "..command)
  end
  
  -- plot the journey if we can!
  line(px, pdepth * 1000, x, depth * 1000)
  px = x
  pdepth = depth
 end
 return {x=x, depth=depth}
end

function journey_val(steps)
 dest = journey(steps)
 return inttext(dest.x * dest.depth)
end

t1 = journey_val({
 "forward 5", "down 5",
 "forward 8", "up 3", "down 8",
 "forward 2"
})
cls(1)
test(t1, 900, "example value = 900")

steps = split(input, "\n")
check(journey_val(steps))
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
77777777777777777111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111771111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111117771111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111117771111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111117711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111177111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111771111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111117711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111177111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111771111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111117771111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111117711111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111177111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111771111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111117711111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111177111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111771111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111117111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111771111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111117711111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111177111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111711111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111177111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111771111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111117111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111711111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111177111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111771111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111117711111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111171111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111117111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111771111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111117111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111771111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111117711111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111171111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111117711111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111177111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111711111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111171111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111117111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111711111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111171111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111117111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111711111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111171111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111117111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111711111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111171111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111117111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111711111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111171111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111117111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111711111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111711111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111171111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111117111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111711111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111171111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111171111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111117111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111711111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111171111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111117111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111117111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111711111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111171111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111171111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111117111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111117111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111711111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111171111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111171111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111117111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111711111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111711111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111171111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111117111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111117111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111711111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111171111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111171111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111117111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111711111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111171111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111171111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111117111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111711
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111171
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111171
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111117
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1bb1b1b1bbb11bb1b1b11111bbb1bb111bb1b1b1bbb1bbb111111111bb11bbb1bbb1bbb1bbb1bbb1bbb1bb11bbb1bbb111111111111111111111111111111111
b111b1b1b111b111b1b11111b1b1b1b1b111b1b1b111b1b11b1111111b11b1b1b1b1b1b1b111b1b111b11b1111b1b11111111111111111111111111111111111
b111bbb1bb11b111bb111111bbb1b1b1bbb1b1b1bb11bb11111111111b11bbb1bbb1b1b1bbb1bbb11bb11b11bbb1bbb111111111111111111111111111111111
b111b1b1b111b111b1b11111b1b1b1b111b1bbb1b111b1b11b1111111b11b1b1b1b1b1b111b111b111b11b11b11111b111111111111111111111111111111111
1bb1b1b1bbb11bb1b1b11111b1b1b1b1bb11bbb1bbb1b1b111111111bbb1bbb1bbb1bbb1bbb111b1bbb1bbb1bbb1bbb111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111

