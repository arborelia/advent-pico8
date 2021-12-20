pico-8 cartridge // http://www.pico-8.com
version 34
__lua__
#include advent.p8

function cave_paths(graph,used)
end

coords = {}
-- haphazardly visualize a graph
function make_coords(graph)
 coords = {}
 local angle=12/53
 local step=0
 for node,out in pairs(graph) do
  if node == "start" then
   coords[node] = {x=10,y=30}
  elseif node == "end" then
   coords[node] = {x=110,y=90}
  else
   coords[node] = {
    x=sin(step*angle)*40+64,
    y=cos(step*angle)*40+64
   }
   step += 1
  end
 end
end

function draw_graph(graph)
 for node,out in pairs(graph) do
  local loc = coords[node]
  for dest in all(out) do
   local loc2 = coords[dest]
   color(3)
   line(loc.x, loc.y, loc2.x, loc2.y)
  end
  cursor(loc.x,loc.y)
  color(12)
  print(node)
 end
end

function draw_path(path, c)
 for i=1,#path-1 do
  local loc = coords[path[i]]
  local loc2 = coords[path[i+1]]
  color(c)
  line(loc.x, loc.y, loc2.x, loc2.y)
 end
end

function make_graph(lines)
 local graph={}
 
 for l in all(lines) do
  nodes = split(l, "-")
  n1 = nodes[1]
  n2 = nodes[2]
  if graph[n1] == nil then
   graph[n1] = {}
  end
  if graph[n2] == nil then
   graph[n2] = {}
  end
  add(graph[n1], n2)
  add(graph[n2], n1)
 end 
 return graph
end

-- this is o(n) and i don't care
function has(list,entry)
 for item in all(list) do
  if (item==entry) return true
 end
 return false
end

function is_big(node)
 -- node starts with a "capital"
 -- letter (shows up as punyfont)
 local c = ord(at(node,1))
 return (c < ord("a"))
end

function npaths(graph,node,visited,twice)
 if (node=="end") then
  -- color(15)
  -- for v=2,#visited-1 do
  --  print(visited[v].." \0")
  -- end
  -- print(" ")
  return minify(1)
 end
  
 local total=0
 for dest in all(graph[node]) do
  if dest != "start" then
   local ok=true
   local next_twice = twice
   if not is_big(dest) then
    if has(visited, dest) then
     if (twice) then
      ok=false
     else
      next_twice=true
     end
    end
   end
   if ok then
    add(visited,dest)
    total += npaths(graph,dest,visited,next_twice)
    -- remove this node from
    -- visited when done
    visited[#visited] = nil
   end
  end
 end
 return total
end

function total_paths(graph)
 local n=npaths(
  graph,
  "start",   --start node
  {"start"}, --visited so far
  false  --no node seen twice
 )
 cursor(0,100)
 color(15)
 return inttext(n)
end
test(is_big("A"), true, "A is big, don't ask")
test(is_big("start"), false, "start is not big")
graph = make_graph(read_lines())
make_coords(graph)
cls(1)
draw_graph(graph)
cursor(0,0)
check(total_paths(graph))

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
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
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111113333111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111111111111111111111111133c1333333331111111111111111111111111111111111111111111111111111111111111111
1111111111111111111111111111111111111111111111111113cc31c11111113333333311111111111111111111111111111111111111111111111111111111
1111111111111111111111111111111111111111111111111113c1c3c1c111111111111133333333111111111111111111111111111111111111111111111111
1111111111111111111111111111111111111111111111111113c3c13cc111111111111111111111333331c1c1c1111111111111111111111111111111111111
11111111113331ccc1ccc1ccc1ccc111111111111111111111131311331111111111111111113333333333c1c1c1111111111111111111111111111111111111
11111111113313333331c1c1c11c1111111111111111111111311311131111111111113333331111131113311c11111111111111111111111111111111111111
1111111111c3c11c11c33333311c11111111111111111111113113111131111133333311111111133111c3c3c1c1111111111111111111111111111111111111
111111111113311c11c1c1c1c33333111111111111111111113113111133333311111111111111311111c131c1c1111111111111111111111111111111111111
1111111111cc311c11c1c1c1c11c1133333311111111111111311333331131111111111111113311111111311311111111111111111111111111111111111111
11111111111133111111111111111111111133333111111333333131111113111111111111131111111111131131111111111111111111111111111111111111
11111111111131311111111111111111111111111333333113111131111111311111111113311111111111131113111111111111111111111111111111111111
11111111111113311111111111111111111333333111111333333131111111131111111131111111111111131111311111111111111111111111111111111111
11111111111113131111111111111111333111111111111131111333331111113111113311111111111111113111311111111111111111111111111111111111
111111111111113311111111111111113331cc111111111131111131113333333311131111111111111111113111131111111111111111111111111111111111
11111111111111313111111111111111c3c33c111111111131111131111111113333331111111111111111111311113111111111111111111111111111111111
11111111111111311311111111111111ccc133c11111111131111131111111111133113333311111111111111311111311111111111111111111111111111111
11111111111111131311111111111111c1c1cc331111111311111113111111113313111111133333311111111131111131111111111111111111111111111111
11111111111111131131111111111111113111133311111311111113111111131111311111111111133333111131111113111111111111111111111111111111
11111111111111113113111111111111111311111331111311111113111113311111131111111111111111333333111111311111111111111111111111111111
11111111111111113113111111111111111311111133313111111113111131111111113111111111111111111113333333131111111111111111111111111111
11111111111111113111311111111111111131111111333111111113113311111111111311111111111111111113111111333111111111111111111111111111
11111111111111111311311111111111111131111111133311111113131111111111111131111111111111111111311111333cc11cc111111111111111111111
11111111111111111311131111111111111113111111113333111113311111111111111113111111111111111111311113133c11c1c111111111111111111111
11111111111111111131113111111111111113111111131133331131311111111111111113311111111111111111131331133111ccc111111111111111111111
11111111111111111131113111111111111111311111131111313311311111111111111111331111111111111111133111133111c11111111111111111111111
11111111111111111131111311111111111111311111131111133131311111111111111111133111111111111111331111133111111111111111111111111111
11111111111111111113111311111111111111131111131113311313311111111111111111113111111111111113113111313111111111111111111111111111
11111111111111111113111131111111111111131111311131111133333111111111111111111311111111111331113111313111111111111111111111111111
11111111111111111111311113111111111111113111313311111111311311111111111111111131111111113111111311313111111111111111111111111111
11111111111111111111311113111111111111113111331111111111133133111111111111111113111111331111111311313111111111111111111111111111
11111111111111111111311111311111111111111313311111111111131311331111111111111111311113111111111133113111111111111111111111111111
11111111111111111111131111311111111111111333111111111111131133113111111111111111131331111111111133113111111111111111111111111111
11111111111111111111131111131111111111113333111111111111131111311331111111111111133111111111111133113111111111111111111111111111
11111111111111111111113111113111111111131133111111111111131111133113311111111111333311111111111133113111111111111111111111111111
11111111111111111111113111113111111113311133111111111111131111111311131111111113111331111111111133113111111111111111111111111111
11111111111111111111113111111311111131111133111111111111131111111133113311111331111133111111111131313111111111111111111111111111
11111111111111111111111311111131113311111131311111111111113111111111311133113111111113311111111131313111111111111111111111111111
11111111111111111111111311111131131111111311311111111111113111111111133111331111111111311111111311311311111111111111111111111111
11111111111111111111111131111113311111111311131111111111113111111111111313133111111111131111111311131311111111111111111111111111
11111111111111111111111131111133111111111311131111111111113111111111111333111331111111113111111311131311111111111111111111111111
11111111111111111111111131113311311111111311113111111111113111111111113111311113111111111311111311113311111111111111111111111111
11111111111111111111111113131111131111113111113111111111113111111111331111133111331111111331113111113311111111111111111111111111
11111111111111111111111113311111131111113111111311111111111311111113111111111311113311111133113111111311111111111111111111111111
11111111111111111111111131311111113111113111111311111111111311111331111111111133111133111113313111111311111111111111111111111111
111111111111111111111111cc311cc1113111113111111131111111111311113111111111111111311111311111331111111311111111111111111111111111
111111111111111111111111cc31c111111311131111111131111111111311331111111111111111133111133111133111111331111111111111111111111111
111111111111111111111111c113c1c1111131131111111131111111111313111111111111111111111311111331133311111331111111111111111111111111
1111111111111111111111111cc3ccc1111131131111111113111111111331111111111111111111111133111113131331111313111111111111111111111111
11111111111111111111111111113111111113311111111113111111113311111111111111111111111111311111331131111313111111111111111111111111
11111111111111111111111111113111111113311111111111311111331131111111111111111111111111133111313313111311311111111111111111111111
11111111111111111111111111113111111111311111111111311113111131111111111111111111111111111311311131311311311111111111111111111111
11111111111111111111111111111311111111331111111111131331111131111111111111111111111111111133111113331311311111111111111111111111
11111111111111111111111111111311111113131111111111133111111131111111111111111111111111111113311111133311131111111111111111111111
111111111111111111111111111111311111131131111111113331111111311111111111111111111111111111131331111133cc1c1c11111111111111111111
111111111111111111111111111111311111131113111111131131111111311111111111111111111111111111131113113333c11c3c11111111111111111111
111111111111111111111111111111311111311113111113311113111111131111111111111111111111111111311111333111c11ccc11111111111111111111
111111111111111111111111111111131111311111311131111113111111131111111111111111111111111111311133333111c3111c11111111111111111111
11111111111111111111111111111113111131111131331111111131111113111111111111111111111111111131331311133ccc3ccc11111111111111111111
11111111111111111111111111111111311131111113111111111131111113111111111111111111111111111133133111111311131311111111111111111111
11111111111111111111111111111111311311111331311111111113111113111111111111111111111111113311311111111133113131111111111111111111
11111111111111111111111111111111311311113111311111111113111113111111111111111111111111331333111111111111313131111111111111111111
11111111111111111111111111111111131311331111131111111111311113111111111111111111111133111311111111111111133313111111111111111111
11111111111111111111111111111111131313111111131111111111311111311111111111111111113311133111111111111111111333111111111111111111
11111111111111111111111111111111113331111111113111111111131111311111111111111111331111313111111111111111111133311111111111111111
111111111111111111111111111111111131c1ccc111111311111111131111311111111111111133111133113111111111111111111111ccc1cc11cc11111111
1111111111111111111111111111111111c3311c1111111311111111113111311111111111113311111311113111111111111111111111c111c1c1c1c1111111
1111111111111111111111111111111111ccc33c1111111131111111113111311111111111331111113111131111111111111111111111cc11c1c1c1c1111111
111111111111111111111111111111111111c1131111111131111111111311311111111133111111331111131111111111111111111111c111c1c1c1c1111111
1111111111111111111111111111111111ccc1cc3311111113111111111311311111113311111113111111131111111111111111111111ccc1c1c1ccc1111111
11111111111111111111111111111111111111111133111111311111111131131111331111111331111111131111111111111111111111111111111111111111
11111111111111111111111111111111111111111111311111311111111131131133111111113111111111311111111111111111111111111111111111111111
111111111111111111111111111111111111111111111331111311111111131333111111113311111111113c11ccc11111111111111111111111111111111111
11111111111111111111111111111111111111111111111331113111111113331111111113111111111111c1c1c1111111111111111111111111111111111111
11111111111111111111111111111111111111111111111113113111111133331111111331111111111111c1c1cc111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111331311113311331111113111111111111111cc11c1111111111111111111111111111111111111
111111111111111111111111111111111111111111111111111133113311111331113311111111111111111cc1ccc11111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111133311111133113111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111111111111111111111111111c1133cc3113331111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111111111111111111111111111c111c111333c111cc111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111111111111111111111111111c11111c111c1c1c11111111111111111111111111111111111111111111111111111111111
1111111111111111111111111111111111111111111111111111111cc1cc1111c1c1c11111111111111111111111111111111111111111111111111111111111
1111111111111111111111111111111111111111111111111111111111111111cc11c11111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111cc11cc111111111111111111111111111111111111111111111111111111111
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
