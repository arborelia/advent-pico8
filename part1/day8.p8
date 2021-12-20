pico-8 cartridge // http://www.pico-8.com
version 34
__lua__
#include advent.p8
#include serial.p8

-- convert a string like abge
-- to bits representing the
-- segments that are on
function segbits(s)
 local n=0
 for ch in all(split(s,"")) do
  n |= shl(1,ord(ch)-ord("a"))
 end
 return n
end

function nsegs(bits)
 local n=0
 for b=0,6 do
  if bits & shl(1,b) > 0 then
   n += 1
  end
 end
 return n
end

function parse_line(l)
 local parts = split(l, "|")
 local res = {examples={}, target={}}
 for digit in all(split(parts[1], " ")) do
  if digit != "" then
   add(res.examples, segbits(digit))
  end
 end
 assert(#res.examples == 10)
 
 for digit in all(split(parts[2], " ")) do
  if digit != "" then
   add(res.target, segbits(digit))
  end
 end
 assert(#res.target == 4)
 
 return res 
end

function count_obvious(lines)
 local c=0
 for l in all(lines) do
  local parsed=parse_line(l)
  for bits in all(parsed.target) do
   local ns=nsegs(bits)
   if ns==2 or ns==3 or ns==4 or ns==7 then
    c += 1
   end
  end
 end
 return c
end

test(segbits("a"), 1, "a")
test(segbits("abcdefg"), 127, "abcdefg")
test(segbits("dab"), 11, "dab")

example = "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"
parsed = parse_line(example)
test(parsed.target, {62, 47, 62, 47})
test(parsed.examples[1], 127)
test(parsed.examples[10], 3)

test(nsegs(127), 7, "7 segments")
test(nsegs(17), 2, "2 segments")

test(count_obvious({example}), 0, "smallest example")

check(count_obvious(read_lines()))

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
