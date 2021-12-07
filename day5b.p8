pico-8 cartridge // http://www.pico-8.com
version 34
__lua__
#include advent.p8
#include serial.p8

function parse_segment(l)
 -- read a line like "5,5 -> 8,2"
 local parts = split(l, "-")
 local parts1 = split(parts[1], ",")
 local parts2 = split(
  -- trim off the first 2 chars
  sub(parts[2], 3),
  ","
 )
 return {
  x1 = parts1[1], y1 = parts1[2],
  x2 = parts2[1], y2 = parts2[2]
 }
end

function parse_lines(lines)
 local segments = {}
 for l in all(lines) do
  add(segments, parse_segment(l))
 end
 return segments
end

function draw_seg(seg, xoffset, yoffset)
 local x=seg.x1
 local y=seg.y1
 local xt=seg.x2
 local yt=seg.y2
 while x != xt or y != yt do
  local c = pget(x-xoffset,y-yoffset)
  if c > 0 then
   pset(x-xoffset, y-yoffset, 2)
  else
   pset(x-xoffset,y-yoffset, 1)
  end
  if (xt > x) x += 1
  if (xt < x) x -= 1
  if (yt > y) y += 1
  if (yt < y) y -= 1
 end
 local c = pget(x-xoffset,y-yoffset)
 if c > 0 then
  pset(x-xoffset, y-yoffset, 2)
 else
  pset(x-xoffset,y-yoffset, 1)
 end
end

function find_overlaps(segs,xscreens,yscreens)
 -- find horiz+vert overlaps
 local overlaps = 0
 for xo=0,xscreens-1 do
  for yo=0,yscreens-1 do
   cls(0)
   xoffset = xo*128
   yoffset = yo*128
		 for seg in all(segs) do
		  draw_seg(seg,xoffset,yoffset)
		 end
		 overlaps += count_overlaps()
		end
	end
	cursor(0,100)
 color(6)
 return overlaps
end

-- look at the pixels on the
-- screen and count how many
-- overlaps there are
function count_overlaps()
 local overlaps = 0
 for x=xoffset,xoffset+127 do
  for y=yoffset,yoffset+127 do
   local c = pget(x-xoffset,y-yoffset)
   if c == 2 then
    overlaps += 1
   end
  end
 end
 return overlaps
end

-- test parse_segment
seg = parse_segment("123,456 -> 7,8")
test(seg.x1, 123, "x1")
test(seg.y1, 456, "y1")
test(seg.x2, 7, "x2")
test(seg.y2, 8, "y2")

-- read in a small example
small_input = [[0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2]]

segs = parse_lines(split(small_input, "\n"))

-- test that we read the right things
test(#segs, 10, "read 10 segments")
test(segs[1].x1, 0, "first segment x1")
test(segs[1].y1, 9, "first segment y1")
test(segs[1].x2, 5, "first segment x2")
test(segs[1].y2, 9, "first segment y2")
test(find_overlaps(segs,1,1), 12, "small example")

segs = parse_lines(read_lines())
check(find_overlaps(segs,8,8))
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
