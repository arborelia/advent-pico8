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
__label__
00111000000100001000000000010000000000000000000000000000000000000000001000000000000000001100000000001000010000000000001000000000
10101100000010000100000000001000000000000000000000000000000000000000000100000000000000001010000000000100001000000000000100000000
01100110000001000010000000000100000000000000000000000000000000000000000010000000000000001001000000000010000100000000000010000000
10200011000000100001000000000010000000000000000000000000000000000000000001000000000000001000100000000001000010000000000001000000
11110001100000010000100000000001000000000000000000000000000000000000000000100000000000001000010000000000100001000000000000100000
01201000110000001000010000000000100000000000000000000000000000000000000000010000000000001000001000000000010000100000000000010000
00210100011000000100001000000000010000000000000000000000000001000000000000001000000000001000000100000000001000010000000000001000
00111010001100000010000100000000001000000000000000000000000000100000000000000100000000001000000010000000000100001000000000000100
00101101000110000001000010000000000100000000000000000000000000010000000000000010000000001000000001000000000010000100000000000010
10100110100011000000100001000000000010000000000000000000000000001000000000000001000000001000000000100000000001000010000000000001
11100011010001100000010000100000000001000000000000000000100000000100000000000000100000001000000000010000000000100001000000000000
01200001101000110000001000010000000000100000000000000000100000000010000000000000010000001000000000001000000000010000100000000000
00210000110100011000000100001000000000010000000000000000100000000001000000000000001000001000000000000100000000001000010000000000
00111000011010001100000010000100000000001000000000000000100000000000100000000000000100001000000000000010000000000100001000000000
00101100001101000110000001000010000000000100000000000000100000000000010000000000000010001000000000000001000000000010000100000000
00100110000110100011000000100001000000000010000000000000100000000000001000000000000001001000000000000000100000000001000010000000
00100011000011010001100000010000100000000001000000000000100000000000000100000000000000101000000000000000010000000000100001000000
00100001100001101000110000001000010000000000100000000000100000000000000010000000000000011000000000000000001000000000010000100000
11211111221111221211122111111211112111111111121111111111211111111111111112111111111111112111111111111111111211111111112111121111
00100000011000011010001100000010000100000000001000000000100000000000000000100000000000001100000000000000000010000000000100001000
10100000001100001101000110000001000010000000000100000000100000000000000000010000000000001010000000000000000001000000000010000100
01100000000110000110100011000000100001000000000010000000100000000000000000001000000000001001000000000000000000100000000001000010
00200000000011000011010001100000010000100000000001000000100000000000000000000100000000001000100000000000000000010000000000100001
00110000000001100001101000110000001000010000000000100000100000000000000000000010000000001000010000000000000000001000000000010000
00101000000000110000110100011000000100001000000000010000100000000000000000000001000000001000001000000000000000000100000000001000
00100100000000011000011010001100000010000100000000001000100000000000001000000000100000001000000100000000000000000010000000000100
00100010000000001100001101000110000001000010000000000100100000000000001000000000010000001000000010000000000000000001000000000010
00100001000000000110000110100011000000100001000000000010100000000000001000000000001000001000000001000000000000000000100000000001
00100000100000000011000011010001100000010000100000000001100000000000001000000000000100001000000000100000000000000000010000000000
00100000010000000001100001101000110000001000010000000000200000000000001000000000000010001000000000010000000000000000001000000000
10100000001000000000110000110100011000000100001000000000110000000000001000000000000001001000000000001000000000000000000100000000
01100000000100000000011000011010001100000010000100000000101000000000001000000000000000101000000000000100000000000000000010000000
00200000000010000000001100001101000110000001000010000000100100000000001000000000000000011000000000000010000000000000000001000000
00110000000001000000000110000110100011000000100001000000100010000000001000000000000000002000000000000001000000000000000000100000
00101000000000100000000011000011010001100000010000100000100001000000001000000000000000001100000000000000100000000000011111121111
00100100000000010000000001100001101000110000001000010000100000100000001000000000000000001010000000000000010000000000000000001000
00100010000000001000000000110000110100011000000100001000100000010000001000000000000000001001000000000000001000000000000000000100
00100001000000000100000000011000011010001100000010000100100000001000001000000000000000001000100000000000000100000000000000000010
00100000100000000010000000001100001101000110000001000010100000000100001000000000000000001000010000000000000010000000000000000001
00100000010000000001000000000110000110100011000000100001100000000010001000000000000000001000001000000000000001000000000000000000
10100000001000000000100000000011000011010001100000010000200000000001001000000000000000001000000100000000000000100000000000000000
01100000000100000000010000000001100001101000110000001000110000000000101000000000000000001000000010000000000000010000000000000000
00200000000010000000001000000000110000110100011000000100101000000000011000000000000000001000000001000000000000001000000000000000
00110000000001000000000100000000011000011010001100000010100100000000002000000000000000001000000000100000000000000100000000000000
00101000000000100000000010000000001100001101000110000001100010000000001100000000000000001000000000010000000000000010000000000000
00100100000000010000000001000000010110000110100011000000200001000000001010000000000000001000000000001000000000000001000000000000
00100010000000001000000000100000010011000011010001100000110000100000001001000000000000001000000000000100000000000000100000100000
10100001000000000100000000010000010001100001101000110000101000010000001000100000000000001000000000000010000000000000010000100000
01100000100000000010000000001000010000110000110100011000100100001000001000010000000000001000000000000001000000000000001000100000
00200000010000000001000000000100010000011000011010001100100010000100001000001000000000001000000000000000100000000000000100100000
00110000001000000000100000000010010000001100001101000110100001000010001000000100000000001000000000000000010000000000000010100000
00101000000100000000010000000001010000000110000110100011100000100001001000000010000000001000000000000000001000000000000001100001
00100100000010000000001000000000110000000011000011010001200000010000101000000001000000001000000000000000000100000000000000200011
00100010000001000000000100000000020000000001100001101000210000001000011000000000100000001000000000000000000010000000000000110110
00100001000000100000000010000000011000000000110000110100111000000100002000000000010000001000000000000000000001000000000000102100
00100000100000010000000001000000010100000000011000011010101100000010001100000000001000001000000000000000000000100000000000111100
00100000010001001000000000100000010010000000001100001101100110000001001010000000000100001000000000000000000000010000000000210010
00100000001000100100000000010000010001000000000110000110200011000000101001000000000010001000000000000000000000001000000001200001
00100000000100010010000000001000010000100000000011000011110001100000011000100000000001001000000000000000000000000100000001100000
00100000000010001001000000000100010000010000000001100001201000110000002000010000000000101000000000000000000000000010000010100000
00100000000001000100100000000010010000001000000000110000210100011000001100001000000000011000000000000000000000000001000100100000
00100000000000100010010000000001010000000100000000011000111010001100001010000100000000002000000000000000000000000000101000100000
00100000000000010001001000000000110000000010000000001100101101000110001001000010000000001100000000000000000000000000020000100000
00100000000000001000100100000000020000000001000000000110100110100011001000100001000000001010000000000000000000000000101000100000
00100000000000000100010010000000011000000000100000000011100011010001101000010000100000001001000000000000000000000001000100100000
00100000000000000010001001000000010100000000010000000001200001101000111000001000010000001000100000000000000000000010000010100000
10100000000000000001000100100000010010000000001000000000210000110100012000000100001000001000010000000000000000000100000001100000
01100000000000000000100010010000010001000000000100000000111000011010002100000010000100001000001000000000000000001000000000200000
00200000000000000000010001001000010000100000000010000000101100001101001110000001000010001000000100000000000000010000000000110000
00110000000000000000001000100100010000010000000001000000100110000110101011000000100001001000000010000000000000100000000000101000
11212111111111111111111211121121121111112111111111211111211122111222122112211111121111212112111112111111111112111111111111211211
00100100000000000000000010001001010000000100000000010000100001100011102000110000001000011001000000100000000010000000000000100010
00100010000000000000000001000100110000000010000000001000100000110001111100011000000100002001000000010000000100000000000000100001
00100001000000000000000000100010020000000001000000000100100000011000112010001100000010001101000000001000001000000000000000100000
00100000100000000000000000010001011000000000100000000010100000001100012101000110000001001011000000000100010000000000000000100000
00100000010000000000000000001000110100000000010000000001100000000110002110100011000000101002000000000010100000000000000000100000
00100000001000000000000000000100020010000000001000000000200000000011001111010001100000011001100000000002000000000000000000100000
00100000000100000000000000000010011001000000000100000000110000000001101011101000110000002001010000000010100000000000000000100000
00100000000010000000000000000001010100100000000010000000101000000000111001110100011000001101001000000100010000000000000000100000
00100000000001000000000000000000110010010000000001000000100100000000012000111010001100001011000100001000001000000000000000100000
00100000000000100000000000000001121112112111111111211111211121111111112211122212111221112112111121121111111211111111111111211111
00100000000000010000000000000000011000100100000000010000100001000000001110001110100011001001100001100000000010000000000000100000
10100000000000001000000000000000010100010010000000001000100000100000001011000111011001101001010001100000000001000000000000100000
01100000000000000100000000000000010010001001000000000100100000010000001001100011101101111001001010010000000000100000000000100000
00200000000000000010000000000000010001000100100000000010100000001000001000110001110111012001000200001000000000010000000000100000
00110000000000000001000000000000010000100010010000000001100000000100001000011000111012002101001010000100000000001000000000100000
00101000000000000000100000000000010000010001001000000000200000000010001000001100011102101111010001000010000000000100000000100000
00100100000000000000010000000000010000001000100100000000110000000001001000000110001111111012100000100001000000000010000000100000
00100010000000000000001000000000010000000100010010000000101000000000101000000011000112012002100000010000100000000001000000100000
00100001000000000000000100000000010000000010001001000000100100000000011000000001100012102111110000001000010000000000100000100000
00100000100000000000000010000000010000000001000100100000100010000000002000000000110002111211011000000100001000000000010000100000
00100000010000000000000001000000010000000000100010010000100001000000001100000000011001112012001100000010000100000000001000100000
00100000001000000000000000100000010000000000010001001000100000100000001010000000001101022102100110000001000010000000000100100000
00100000000100000000000000010000010000000000001000100100100000010000001001000000000111102111110011000000100001000000000010100000
00100000000010000000000000001000010000000000000100010010100000001000001000100000000012001112011001100000010000100000000001100000
00100000000001000000000000000100010000000000000010001001100000000100001000010000000012101012101100110000001000010000000000200000
00100000000000100000000000000010010000000000000001000100200000000010001000001000000101111002110110011000000100001000000000110000
00100000000000010000000000000001010000000000000000100010110000000001001000000100001001012001111011001100000010000100000000101000
00100000000000001000000000000000110000000000000000010001101000000000101000000010010001002101011101100110000001000010000000100100
00100000000000000100000000000000020000000000000000001000200100000000011000000001100001001111001110110011000000100001000000100010
00100000000000000010000000000000011000000000000000000100110010000000002000000001100001001012000111011001100000010000100000100001
00100000000000000001000000000000010100000000000000000010101001000000001100000010010001001002100011101100110000001000010000100000
00100000000000000000100000000000010010000000000000000001100100100000001010000100001001001001110001110110011000000100001000100000
11211111111111111111121111111111121112111111111111111111211121121111112112112111111212112112122111222122112211111121111211211111
00100000000000000000001000000000010000100000000000000000110001001000001000110000000011001001001100011101100110000001000010100000
00100000000000000000000100000000010000010000000000000000101000100100001000110000000002001001000110001110110011000000100001100000
00100000000000000000000010000000010000001000000000000000100100010010001001001000000001101001000011000111011001100000010000200000
10100000000000000000000001000000010000000100000000000000100010001001001010000100000001011001000001100011101100110000001000110000
01100000000000000000000000100000010000000010000000000000100001000100101100000010000001002001000000110001110110011000000100101000
00200000000000000000000000010000010000000001000000000000100000100010012000000001000001001101000000011000111011001100000010100100
00110000000000000000000000001000010000000000100000000000100000010001012000000000100001001011000000001100011101100110000001100010
00101000000000000000000000000100010000000000010000000000100000001000201100000000010001001002000000000110001110110011000000200001
00100100000000000000000000000010010000000000001000000000100000000101011010000000001001001001100000000011000111011001100000110000
00100010000000000000000000000001010000000000000100000000200000000020002001000000000101001001010000000001100011101100110000101000
00100001000000000000000000000000110000000000000010000000200000000101001100100000011122112112112111111111221112221221122111211211
00100000100000000000000000000000020000000000000001000000200000001000101010010000000002001001000100000000011000111011001100100010
00100000010000000000010000000000011000000000000000100000200000010000011001001000000001101001000010000000001100011101100110100001
00100000001000000000010000000000010100000000000000010000200000100000002000100100000001011001000001000000000110001110110011100000
00100000000100000000010000000000010010000000000000001000200001000000001100010010000001002001000000100000000011000111011001200000
00100000000010000000010000000000010001000000000000000100200010000000001010001001000001002101000000010000000001100011101100210000
10100000000001000000010000000000010000100000000000000010200100000000001001000100100001002011000000001000000000110001110110111000
01100000000000100000010000000000010000010000000000000001201000000000001000100010010001002002000000000100000000011000111011101100
00200000000000010000010000000000010000001000000000000000210000000000001000010001001001002001100000000010000000001100011101200110
00110000000000001000010000000000010000000100000000000000210000000000001000001000100101002001010000000001000000000110001110210011
00101000000000000100010000000000010000000010000000000001201000000000001000000100010011002001001000000000100000000011000111111001
00100100000000000010010000000000010000000001000000000010200100000000001000000010001002002001000100000000010000000001100011201100
00100010000000000001010000000000010000000000100000000100200010000000001000000001000101102001000010000000001000000000110001210110
00100001000000000000110000000000010000000000010000001000200001000000001000000000100011012001000001000000000100000000011000211011
