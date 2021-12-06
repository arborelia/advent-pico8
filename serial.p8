pico-8 cartridge // http://www.pico-8.com
version 34
__lua__
function serial_input()
 local base = 0x0000
 print("\ace ready for input")
 
 -- wait until there's input
 while not stat(120) do
 end
 
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
