pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
#include serial.p8
#include advent.p8

ulp = 0x0.0001

function ones_at_pos(tbl, p)
 local c = 0
 for bits in all(tbl) do
  if (at(bits,p) == "1") c += 1
 end
 return c
end

function draw_tbl(tbl)
 cls(0)
 for row=1,#tbl do
  local entry = tbl[row]
  for col=1,#entry do
   local bit = at(entry,col)
   if bit == "1" then
    pset(col,row,15)
   elseif bit == "0" then
    pset(col,row,3)
   else
    assert(false, bit)
   end
  end
  if (row >= 128) break
 end
 cursor(0,40)
 flip()
end

function oxy_rating(tbl)
 local oxy = 0
 local width = #tbl[1]
 for p=1,width do
  draw_tbl(tbl)
  
  -- find the most common bit
  -- in oxy entries
  -- increment the next digit
  -- of oxy if it's 1

  local ones = ones_at_pos(tbl,p)
  local bit = "0"
  oxy *= 2
  if (ones >= #tbl - ones) then
   bit = "1"
   oxy += ulp
  end
  
  -- keep the appropriate entries
  local newtbl = {}
  for bits in all(tbl) do
   if at(bits,p) == bit then
    add(newtbl, bits)
   end
  end
  tbl = newtbl
 end
 return oxy
end

function co2_bits(tbl)
 local width = #tbl[1]
 for p=1,width do
  assert(#tbl > 0)
  draw_tbl(tbl)
  
  if #tbl > 1 then
   -- find the most common bit
   -- in co2 entries
   -- increment the next digit
   -- of co2 if it's 1

	  local ones = ones_at_pos(tbl,p)
	  local bit = "1"
	  if (ones >= #tbl - ones) then
	   bit = "0"
	  end
	  
	  -- keep the appropriate entries
	  local newtbl = {}
	  for bits in all(tbl) do
	   if at(bits,p) == bit then
	    add(newtbl, bits)
	   end
	  end
	  tbl = newtbl
	 else  -- table size is 1
	  -- so return the entry
	  return tbl[1]
	 end
 end
 assert(false,#tbl)
end

function from_bits(str)
 val = 0
 for bit in all(split(str,"")) do
  val *= 2
  val += ulp*bit
 end
 return val
end

function co2_rating(tbl)
 return from_bits(co2_bits(tbl))
end

function life_support(tbl)
 local oxy = oxy_rating(tbl)
 local co2 = co2_rating(tbl)
 return inttext(mul32(oxy,co2))
end

test_in = {
 "00100",
 "11110",
 "10110",
 "10111",
 "10101",
 "01111",
 "00111",
 "11100",
 "10000",
 "11001",
 "00010",
 "01010"
}
test(
 shl(from_bits("1010"),16),
 10,
 "from_bits" 
)
test(
 shl(oxy_rating(test_in),16),
 23,
 "oxygen rating"
)
test(
 shl(co2_rating(test_in),16),
 10,
 "co2 rating"
)
test(
 life_support(test_in),
 "230",
 "life support"
)

input = read_lines()
check(life_support(input))
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
