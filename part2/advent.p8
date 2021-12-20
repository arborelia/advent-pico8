pico-8 cartridge // http://www.pico-8.com
version 34
__lua__
-- tests & debugging

function pause()
 while btn(🅾️) or btn(❎) do
  flip()
 end
 while not btn(🅾️) or btn(❎) do
  flip()
 end
end

-- if we passed the test on
-- the site, celebrate
function yay()
 star()
 cursor(28, 90)
 print("\ac1g2c3e3c4")
 color(10)
 print("you did the thing!")
 
 pause()
end

function star()
 cls(1)
 
 -- draw a fancy textured star.
 -- it's okay that it takes
 -- a while to draw because
 -- that makes it look cooler
 local nsteps=20000
 for step=1,nsteps do
  local angle = step / nsteps + .25
  local wobble = sin(angle * 5)
  local radius = 20 + wobble*5
  if radius > 20 then
   radius += wobble * wobble * 5
  end
  local x = 64 + cos(angle) * radius
  local y = 64 - sin(angle) * radius
  line(64, 64, x, y, 9)
  
  radius *= 0.8
  x = 64 + cos(angle) * radius
  y = 64 - sin(angle) * radius
  line(64, 64, x, y, 10)
 end
end

function check(answer)
 color(11)
 print("check answer: "..answer)
 pause()
 if (btn(🅾️)) yay()
end

function test(result, expected, name)
 if type(result) != type(expected) then
  color(8)
  print("\ae- 😐 \0")
  print("expected "..type(expected)..", got "..type(result))
  assert(false)
 else
  -- we can't print bools???
  if result==true then
   result = "true"
  end
  if result==false then
   result = "false"
  end
  if result==nil then
   result = "nil"
  end
  if expected==true then
   expected = "true"
  end
  if expected==false then
   expected = "false"
  end
  if expected==nil then
   expected = "nil"
  end
  
  -- compare tables
  if type(result) == "table" then
   return test_list(result, expected, name)
  end

  checktext = result.." = "..expected
  if result == expected then
   succeed(name, result)
  else
   fail(name, result.." != "..expected)
  end
 end
end

function test_list(result, expected, name)
 if #result == 0 then
  color(10)
  print("\ae- 😐 can't test keys")
  return
 end
 if #result != #expected then
  fail(name, "#elements "..#expected.." != "..#result)
 end
 for i=1,#expected do
  if result[i] != expected[i] then
   fail(name, "["..i.."] "..result[i].." != "..expected[i])
  end
 end
 succeed(name, "[table]")
end

function succeed(name, msg)
 color(11)
 print("\ag ♥ \0")
 color(7)
 if name != nil then
  print(name..": \0")
 end
 print(msg)
end

function fail(name, msg)
 color(8)
 print("\ae- ❎ \0")
 color(7)
 if name != nil then
  print(name..": \0")
 end
 print(msg)
 assert(false)
end

-->8
-- number stuff
function minify(num)
 return shr(num,16)
end

function bigify(num)
 return shl(num,16)
end

function inttext(val)
 return tostr(val, 2)
end

function bigmul(a, b)
 -- returns a string of a * b
 -- a and b are fixed point nums
 prod = minify(a) * b
 return inttext(prod)
end

function mul32(a, b)
 -- multiplies a * b
 -- where both of them are 32bit ints
 -- so one of them needs to be shifted
 return a * bigify(b,16)
end

-->8
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
  if carry == 0 and d >= #a and d >= #b then
   break
  end
 end
 return result
end

function bigsub(a,b)
 local result={}
 local borrow=0
 for d=1,80 do
  local diff = (a[d] or 0) - (b[d] or 0) - borrow
  if diff < 0 then
   diff += 10
   borrow = 1
  else
   borrow = 0
  end
  add(result, diff)
  if d >= #a and d >= #b then
   break
  end
 end
 assert(borrow==0, "negative numbers are scary")
 return result
end

function dectext(val)
 local text = ""
 for i=#val,1,-1 do
  text ..= val[i]
 end
 return text
end

-- a and b are lists of digits
-- from most to least significant
-- like {4,2,0} means 420
--
-- return true if a < b
function digits_less(a, b)
 if (#a < #b) return true
 if (#a > #b) return false
 local size=#a
 for i=0,size-1 do
  if (a[#a-i] < b[#b-i]) return true
  if (a[#a-i] > b[#b-i]) return false
 end
 return false
end

function digits_sort(a)
 for i=1,#a do
  local j = i
  while j > 1 and digits_less(a[j], a[j-1]) do
   a[j],a[j-1] = a[j-1],a[j]
   j = j - 1
  end
 end
end


-->8
-- indexing & sorting
function at(str, pos)
 return sub(str, pos, pos)
end

function insertion_sort(a)
 for i=1,#a do
  local j = i
  while j > 1 and a[j-1] > a[j] do
   a[j],a[j-1] = a[j-1],a[j]
   j = j - 1
  end
 end
end

-- get a median of the table
-- (smaller of the two if there
-- is an even number of items)
function median(tbl)
 insertion_sort(tbl)
 local mid=ceil(#tbl/2)
 return tbl[mid]
end

-->8
-- reading file input

function cursor_row()
 return peek(0x5f27)
end

function serial_input()
 local base = 0x0000
 color(6)
 local cur=cursor_row()
 print("\ace ● ready for input\0")
 
 -- a cycle of colors to animate
 local angle = 0
 local scale={
  [0]=1, 2, 8, 9, 10, 15, 7, 7
 }
 
 -- wait until there's input
 while not stat(120) do
  angle += 1/64
  local c=flr((cos(angle)+1) * 3.5)
  color(scale[c])
  cursor(0, cur)
  print("●\0")
  flip()
 end
 
 color(7)
 print("\afb-")
 
 local line = ""
 while stat(120) do
  local len = serial(0x800, base, 0x1000)
  for i=0,len-1 do
   local c=chr(@(base+i))
   if c=="\n" then
    handle_line(line)
    line = ""
   elseif c != "\r" then
    line ..= c
   end
  end
 end
end

-- a global shared by the default
-- handle_line and read_lines
_lines = {}

-- a cart can override the handle_line
-- function, I think
function handle_line(line)
 add(_lines, line)
end

function read_lines()
 _lines = {}
 serial_input()
 ?#_lines.." lines read"
 return _lines
end


__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
