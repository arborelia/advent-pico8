pico-8 cartridge // http://www.pico-8.com
version 34
__lua__
#include advent.p8
#include serial.p8

-- takes a table whose keys
-- are a set of small numbers
-- returns the numbers in order
function counting_sort(set)
 local sorted={}
 for i=0,999 do
  if set[i] != nil then
   add(sorted, i)
  end
 end
 return sorted
end

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

function read_lines(lines)
 local segments = {}
 for l in all(lines) do
  add(segments, parse_segment(l))
 end
 return segments
end

-- take in list of line segments
-- return the ones that are
-- horizontal or vertical
function filter_orthogonal(segs)
 local orth = {}
 for seg in all(segs) do
  if (seg.x1 == seg.x2 or
      seg.y1 == seg.y2) then
   add(orth, seg)
  end
 end
 return orth
end

function filter_horizontal(segs)
 local got = {}
 for seg in all(segs) do
  if seg.y1 == seg.y2 then
   add(got, seg)
  end
 end
 return got
end

function filter_vertical(segs)
 local got = {}
 for seg in all(segs) do
  if seg.x1 == seg.x2 then
   add(got, seg)
  end
 end
 return got
end

-- find just the x and y
-- coordinates that matter
function coord_tables(segs)
 local xset = {}
 local yset = {}
 for seg in all(segs) do
  xset[seg.x1] = true
  xset[seg.x1+1] = true
  xset[seg.x2] = true
  xset[seg.x2+1] = true
  yset[seg.y1] = true
  yset[seg.y1+1] = true
  yset[seg.y2] = true
  yset[seg.y2+1] = true
 end
 local tab = {
  xs = counting_sort(xset),
  ys = counting_sort(yset),
  xmap = {},
  ymap = {}
 }
 
 -- build the reverse mapping
 for xnum=1,#tab.xs do
  local x = tab.xs[xnum]
  tab.xmap[x] = xnum
 end
 for ynum=1,#tab.ys do
  local y = tab.ys[ynum]
  tab.ymap[y] = ynum
 end
 return tab
end

-- bit math for lines+intersections
-- these get combined together
-- to make numbers that happen
-- to also be colors
hdot = 1
hmore = 2
vdot = 4
vmore = 8

function draw_horiz(seg, tab)
 local y = tab.ymap[seg.y1]
 local x1 = tab.xmap[seg.x1]
 local x2 = tab.xmap[seg.x2]
 local xmin = min(x1,x2)
 local xmax = max(x1,x2)
 for x=xmin,xmax do
  local c = pget(x,y)
  if c & hdot == hdot then
   pset(x,y,c | hmore)
  else
   pset(x,y,c | hdot)
  end
 end
end

function draw_vert(seg, tab)
 local x = tab.xmap[seg.x1]
 local y1 = tab.ymap[seg.y1]
 local y2 = tab.ymap[seg.y2]
 local ymin = min(y1,y2)
 local ymax = max(y1,y2)
 for y=ymin,ymax do
  local c = pget(x,y)
  if c & vdot == vdot then
   pset(x,y,c | vmore)
  else
   pset(x,y,c | vdot)
  end
 end
end

function find_overlaps(segs)
 cls(0)
 local tab = coord_tables(segs)
 local horiz = filter_horizontal(segs)
 local vert = filter_vertical(segs)
 local c = 3
 -- find horiz+vert overlaps
 for seg in all(horiz) do
  draw_horiz(seg,tab)
 end
 for seg in all(vert) do
  draw_vert(seg,tab)
 end
 cursor(0,100)
 color(10)
 print(count_overlaps(tab))
end

-- look at the pixels on the
-- screen and figure out how
-- many overlaps they actually
-- count for
function count_overlaps(tab)
 local overlaps = 0
 for x=0,127 do
  for y=0,127 do
   local c = pget(x,y)
   if c & (hdot | vdot) == (hdot | vdot) then
    overlaps += 1
   else
    if c & hmore == hmore then
     overlaps += tab.xs[x+1] - tab.xs[x]
    end
    if c & vmore == vmore then
     overlaps += tab.ys[y+1] - tab.ys[y]
    end
   end
  end
 end
 return overlaps
end

-- test the sort function
myset = {[420]=true, [69]=true}
sortedset = counting_sort(myset)
test(#sortedset, 2, "sorted 2 things")
test(sortedset[1], 69, "nice")
test(sortedset[2], 420, "memes")

-- test parse_segment
seg = parse_segment("123,456 -> 7,8")
test(seg.x1, 123, "x1")
test(seg.y1, 456, "y1")
test(seg.x2, 7, "x2")
test(seg.y2, 8, "y2")

-- read in a small example
-- like theirs but more interesting
small_input = [[0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
3,2 -> 3,1
7,0 -> 7,4
7,2 -> 7,9
0,9 -> 3,9
0,4 -> 3,4
0,0 -> 8,8
5,5 -> 8,2]]
segs = read_lines(split(small_input, "\n"))

-- test that we read the right things
test(#segs, 10, "read 10 segments")
test(segs[1].x1, 0, "first segment x1")
test(segs[1].y1, 9, "first segment y1")
test(segs[1].x2, 5, "first segment x2")
test(segs[1].y2, 9, "first segment y2")
orth = filter_orthogonal(segs)
test(#orth, 7, "7 are orthogonal")
vert = filter_vertical(segs)
test(#vert, 3, "3 are vertical")
-- test finding relevant coordinates
coords = coord_tables(orth)
test(coords.xs, {0,1,3,4,5,6,7,8,9,10}, "x coords")
test(coords.xmap[9], 9, "reverse mapping")

find_overlaps(segs)
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
