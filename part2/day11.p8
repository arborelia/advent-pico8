pico-8 cartridge // http://www.pico-8.com
version 34
__lua__
#include advent.p8

scale = {
 [0]=0, 1, 2, 5, 3,
 8, 14, 9, 10, 15, 7
}

function show_octos(tbl)
 for row=1,10 do
  for col=1,10 do
   local val=tbl[row][col]
   rectfill(
    col*6, row*6,
    col*6+5, row*6+5,
    scale[val]
   )
  end
 end
end

sample_grid = {
 "5483143223",
 "2745854711",
 "5264556173",
 "6141336146",
 "6357385478",
 "4167524645",
 "2176841721",
 "6882881134",
 "4846848554",
 "5283751526"
}

real_grid = {
 "5665114554",
 "4882665427",
 "6185582113",
 "7762852744",
 "7255621841",
 "8842753123",
 "8225372176",
 "7212865827",
 "7758751157",
 "1828544563"
}

function simulate(grid, steps)
 -- get a grid entry, or nil
 -- if it's outside the grid
 function gget(r, c)
  if (grid[r] == nil) return nil
  return grid[r][c]
 end

 local nflashed=0
 for step=1,steps do
	 local flashes={}
	 for r=1,10 do
	  for c=1,10 do
	   grid[r][c] += 1
	   if grid[r][c] >= 10 then
	    add(flashes, {row=r, col=c})
	   end
	  end
	 end
	 
	 -- loop through the flashes,
	 -- adding more as we go
	 local i=1
	 while i <= #flashes do
	  local flash=flashes[i]
	  for r=flash.row-1,flash.row+1 do
	   for c=flash.col-1,flash.col+1 do
	    local val=gget(r,c)
	    if (val != nil and
	        val < 10) then
	     grid[r][c] += 1
	     if gget(r,c) >= 10 then
	      add(flashes, {row=r, col=c})
	     end
	    end
	   end
	  end
	  i += 1
	 end
	 
	 cls(13)
	 show_octos(grid)
	 flip()
	
	 -- set energy of flashed octos
	 -- to 0
	 for r=1,10 do
	  for c=1,10 do
	   if grid[r][c] >= 10 then
	    grid[r][c] = 0
	    nflashed += 1
	   end
	  end
	 end

	 color(7)
	 cursor(0,0)
	 print("step "..step)
	 cursor(64,0)
	 print("#flashed "..nflashed)
	 cursor(0,80)

	end
	return nflashed
end

function read_grid(lines)
 local tbl={}
 for l in all(lines) do
  add(tbl, split(l, ""))
 end
 return tbl
end

grid = read_grid(sample_grid)
test(simulate(grid, 100), 1656)
pause()

check(
 simulate(read_grid(real_grid), 100)
)

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
