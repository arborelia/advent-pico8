pico-8 cartridge // http://www.pico-8.com
version 34
__lua__
#include advent.p8
#include serial.p8

-- decimal bignums!
-- they're not efficient but
-- at least we don't have to
-- convert bases at the end

function bigadd(a,b)
 local result = {}
 local carry = 0
 for d=1,80 do
  local sum = (a[d] or 0) + (b[d] or 0) + carry
  if sum >= 10 then
   sum -= 10
   carry = 1
  else
   carry = 0
  end
  add(result, sum)
  if carry == 0 and d > #a and d > #b then
   break
  end
 end
 
 -- trim leading zeros
 local n=#result
 for d=n,1,-1 do
  if result[d] == 0 then
   result[d] = nil
  else
   break
  end
 end
 return result
end

function empty_array(n)
 local arr = {}
 for i=1,n do
  arr[i] = {0}
 end
 return arr
end

-- number of days to simulate
ndays = 265

function plot(y,val)
 -- plot a decimal number as
 -- colors
 local xoffset = flr(y / 128) * 32
 for x=1,#val do
  pset(x+xoffset,y%128,val[x]+1)
 end
end

function lanternfish_table()
 local born = empty_array(ndays)
 local totals = empty_array(ndays)
 born[1] = {1}
 
 cls(0)
 for day=1,ndays do
  local fish=born[day]
  plot(day,fish)
  -- print("day "..day..": "..fish)
  for bday=day+9,ndays,7 do
   born[bday] = bigadd(
    born[bday],
    fish
   )
  end
 end
 
 local total={0}
 for day=1,ndays do
  total = bigadd(total, born[day])
  totals[day] = total
 end
 return totals
end

totals = lanternfish_table()
pause()

function dectext(val)
 local text = ""
 for i=#val,1,-1 do
  text ..= val[i]
 end
 return text
end

target_days = 256
function count_fish(offsets)
 cls(0)
 local total = {0}
 for i=1,#offsets do
  f = offsets[i]
  total = bigadd(
   totals[target_days+9-f],
   total
  )
  plot(i,total)
 end
 cursor(0,40)
 color(7)
 print(#total)
 print(dectext(total))
 return dectext(total)
end

test(
 bigadd({8,9},{5}),
 {3,0,1},
 "98 + 5 = 103"
)

test(
 bigadd({5}, {8,9}),
 {3,0,1},
 "5 + 89 = 103"
)

test(
 bigadd({0}, {1}),
 {1},
 "0 + 1 = 1"
)

test(
 dectext({9,6,0,2,4}),
 "42069",
 "show decimal as text"
)

test(
 count_fish({3,4,3,1,2}),
 "26984457539",
 "small example"
)

input = split(read_lines()[1], ",")
check(count_fish(input))

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
00000000000000000000000000000000027620000000000000000000000000000864876623000000000000000000000000000000000000000000000000000000
0200000000000000000000000000000007457000000000000000000000000000077269a624000000000000000000000000000000000000000000000000000000
010000000000000000000000000000000592300000000000000000000000000005889a7193000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000003657000000000000000000000000000012a396a44000000000000000000000000000000000000000000000000000000
010000000000000000000000000000000a6550000000000000000000000000000856478984000000000000000000000000000000000000000000000000000000
01000000000000000000000000000000025260000000000000000000000000000679979864000000000000000000000000000000000000000000000000000000
010000000000000000000000000000000331900000000000000000000000000009743322a5000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000004974000000000000000000000000000071a679aa4000000000000000000000000000000000000000000000000000000
01000000000000000000000000000000035522000000000000000000000000000699248a96000000000000000000000000000000000000000000000000000000
010000000000000000000000000000000658400000000000000000000000000002427737a5000000000000000000000000000000000000000000000000000000
02000000000000000000000000000000099932000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000045770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000004a622000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000029532000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000053990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000575a2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000093580000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02000000000000000000000000000000014453000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000099412000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02000000000000000000000000000000029553000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000532a2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000082513000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000065a24000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000036372000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0200000000000000000000000000000005a845000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000072982000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
03000000000000000000000000000000022995000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000326a3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0200000000000000000000000000000009a955000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000a7126000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000a7774000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
020000000000000000000000000000000a4868000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000097154000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0400000000000000000000000000000006173a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000093485000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
040000000000000000000000000000000a184a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000029619000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02000000000000000000000000000000087629000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02000000000000000000000000000000091973200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000084818000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05000000000000000000000000000000055497200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000007a429000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000000000000000000000000000000052479200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000a1a83200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05000000000000000000000000000000078368200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
020000000000000000000000000000000a9481300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02000000000000000000000000000000051436200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0600000000000000000000000000000003626a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000044236200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01200000000000000000000000000000096756400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000614a1300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0120000000000000000000000000000001a627400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0200000000000000000000000000000009a364400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06000000000000000000000000000000019683400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000000000000000000000000000000025631600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02000000000000000000000000000000084551400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
062000000000000000000000000000000129a5700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000094527400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01300000000000000000000000000000095372800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02000000000000000000000000000000041755600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
062000000000000000000000000000000182a9700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
080000000000000000000000000000000a4984900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000000000000000000000000000000082134700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02300000000000000000000000000000026436220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02000000000000000000000000000000068967700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06400000000000000000000000000000096177420000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02000000000000000000000000000000025171a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06400000000000000000000000000000092561520000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09000000000000000000000000000000035539420000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02300000000000000000000000000000089223420000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0930000000000000000000000000000001a21aa20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0800000000000000000000000000000003a98a320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
076000000000000000000000000000000a1592630000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
03000000000000000000000000000000072a28620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01800000000000000000000000000000078528830000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a000000000000000000000000000000049599330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07600000000000000000000000000000061773830000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07400000000000000000000000000000034738440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
093000000000000000000000000000000a81a2730000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
059000000000000000000000000000000aa691650000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0000000000000000000000000000000919a7930000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
073200000000000000000000000000000699a9360000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
022000000000000000000000000000000aa417940000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0732000000000000000000000000000002919a560000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06500000000000000000000000000000062227760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05900000000000000000000000000000059765460000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01320000000000000000000000000000024329980000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08400000000000000000000000000000089999560000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0123000000000000000000000000000005959a8a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01300000000000000000000000000000081314870000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
03630000000000000000000000000000077a89812000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
076000000000000000000000000000000526236a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01230000000000000000000000000000067845912000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06720000000000000000000000000000075435642000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02320000000000000000000000000000028654912000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
014400000000000000000000000000000628a8782000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0860000000000000000000000000000005a1a2332000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
03750000000000000000000000000000016579613000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07800000000000000000000000000000023826372000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
03750000000000000000000000000000024824723000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02330000000000000000000000000000017947143000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02440000000000000000000000000000074498723000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06a50000000000000000000000000000027133324000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09820000000000000000000000000000067746143000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
03a80000000000000000000000000000067277394000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04420000000000000000000000000000062918593000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
053a0000000000000000000000000000029292335000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08a300000000000000000000000000000296624a4000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04a80000000000000000000000000000087112445000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07280000000000000000000000000000023a69356000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a160000000000000000000000000000021134855000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
089320000000000000000000000000000733995a7000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02240000000000000000000000000000019553626000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07282000000000000000000000000000075459519000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0145000000000000000000000000000007a479887000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08282000000000000000000000000000095393669000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0421200000000000000000000000000003162174a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
03142000000000000000000000000000097135199000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04113000000000000000000000000000085258843200000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0139000000000000000000000000000002957637a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04114000000000000000000000000000038638aa5200000000000000000000000000000000000000000000000000000000000000000000000000000000000000
025800000000000000000000000000000789124a2200000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0445400000000000000000000000000005a632177200000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0455200000000000000000000000000009a989427200000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a214000000000000000000000000000072418648200000000000000000000000000000000000000000000000000000000000000000000000000000000000000
072140000000000000000000000000000a5768482300000000000000000000000000000000000000000000000000000000000000000000000000000000000000
033230000000000000000000000000000a569a359200000000000000000000000000000000000000000000000000000000000000000000000000000000000000
071160000000000000000000000000000a2875848300000000000000000000000000000000000000000000000000000000000000000000000000000000000000
