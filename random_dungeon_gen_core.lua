rdg = {};
   -- -- -- -- -- -- -- -- -- -- -- --
   -- Initialize dungeon stuff
   -- -- -- -- -- -- -- -- -- -- -- --

   -- -- -- -- -- -- -- -- -- -- -- --
   -- Width and Height of the Dungeon
   -- -- -- -- -- -- -- -- -- -- -- --
   iDUNGEON_WIDTH = 26;
   iDUNGEON_HEIGHT = 34;



function init_dungeon()


   -- -- -- -- -- -- -- -- -- -- -- --
   -- Map Variables
   -- -- -- -- -- -- -- -- -- -- -- --
   aaVISITED = {};
   aaWALLS = {};
   for i=1,iDUNGEON_WIDTH do
      aaVISITED[i] = {};
	  aaWALLS[i] = {}
	  for j=1,iDUNGEON_HEIGHT do
	     --set all to not-visited
	     aaVISITED[i][j] = false;

		 --set all walls of all cells to true
		 aaWALLS[i][j] = {};
		 for k=1,4 do
		    aaWALLS[i][j][k] = true;
		 end
	  end
   end
end

function random_cell(criteria)
   -- -- -- -- -- -- -- -- -- -- -- --
   -- Get a random cell based on criteria
   -- -- -- -- -- -- -- -- -- -- -- --
   local rnd_cell;
   repeat
      rnd_cell = {
	     x = math.random(1, iDUNGEON_WIDTH),
	     y = math.random(1, iDUNGEON_HEIGHT)
	  };
   until (criteria(rnd_cell))

   return rnd_cell;
end

function random_direction()
   return math.random(1, 4);
   --LDRU:
   -- 1 = left, 2 = down, 3 = right, 4 = up
end

function opposite_direction(dir)
   -- -- -- -- -- -- -- -- -- -- -- --
   -- determine the direct opposite direction
   -- -- -- -- -- -- -- -- -- -- -- --
   if (dir == 1) then
      return 3
   elseif (dir == 2) then
      return 4
   elseif (dir == 3) then
      return 1
   elseif (dir == 4) then
      return 2
   end
end

function cell_in_direction(current, dir)
   if (dir == 1) then
      return {x=current.x-1, y=current.y};
   elseif (dir == 2) then
      return {x=current.x, y=current.y+1};
   elseif (dir == 3) then
      return {x=current.x+1, y=current.y};
   elseif (dir == 4) then
      return {x=current.x, y=current.y-1};
   end
end

function are_all_true(bool_list)
   for i,v in ipairs(bool_list) do
      if (v == false) then return false; end
   end
   return true;
end

function are_all_true_2d(bool_list)
   for i,v in ipairs(bool_list) do
      for i2,v2 in ipairs(v) do
	     if (v2 == false) then return false; end
	  end
   end
   return true;
end

function cell_exists(cell)
   return (cell.x > 0 and cell.x <= iDUNGEON_WIDTH and cell.y > 0 and cell.y <= iDUNGEON_HEIGHT);
end

function cell_visited(cell)
   return aaVISITED[cell.x][cell.y];
end

function mark_visited(cell)
   aaVISITED[cell.x][cell.y]  = true;
end

function gen_maze()

   local visit_count = 0;
   local random_dir, current_cell, adjacent_cell, validity;
   local function rand_criteria(cell) return not cell_visited(cell); end
   local function rand_criteria2(cell) return cell_visited(cell); end
   -- -- -- --
   -- 1: Initialize the Grid
   -- -- -- --
   init_dungeon();

   -- -- -- --
   -- 2: Pick a random cell and mark it visited
   -- -- -- --
   current_cell = random_cell(rand_criteria);
   mark_visited(current_cell);
   visit_count = visit_count+1;
   random_dir = random_direction();

   while (visit_count < iDUNGEON_WIDTH*iDUNGEON_HEIGHT) do
      -- -- -- --
      -- 3: Go in a random direction from current_cell
      -- -- -- --
      if (fDIRECTION_BIAS*100 >= math.random(1,100)) then
         random_dir = random_direction();
      end
      adjacent_cell = cell_in_direction(current_cell, random_dir);
      validity = cell_exists(adjacent_cell) and not (cell_visited(adjacent_cell));

      -- -- -- --
      -- 4: Create corridor to valid neighbor
      -- -- -- --
      if (validity == true) then
         aaWALLS[current_cell.x][current_cell.y][random_dir] = false;
         aaWALLS[adjacent_cell.x][adjacent_cell.y][opposite_direction(random_dir)] = false;
	     mark_visited(adjacent_cell);
		 visit_count = visit_count+1;
	     current_cell = adjacent_cell;
      else
         current_cell = random_cell(rand_criteria2);
      end
   end
end


function count(list, item)
   local cnt = 0;
   for i,v in ipairs(list) do
      if (v == item) then cnt = cnt + 1; end
   end
   return cnt;
end

function find_the_true_one(list)
   for i,v in ipairs(list) do
      if (v == false) then return i; end
   end
end

function sparsify()
   --scan all cells to find dead-ends
   for i,v in ipairs(aaWALLS) do
      for i2,v2 in ipairs(v) do
	     if (count(v2, true) == 3) then
		    --find the true one
			local index = find_the_true_one(v2);

			--change walls of it and adj. one
			aaWALLS[i][i2][index] = true;
			local adj_cell = cell_in_direction({x=i,y=i2}, index);
			aaWALLS[adj_cell.x][adj_cell.y][opposite_direction(index)] = true;
		 end
	  end
   end
end

function random_carving_direction(x, y)
   local rdir;
   repeat
      rdir = random_direction();
   until (aaWALLS[x][y][rdir] == true);
   return rdir;
end

function is_in(cell, region)
   if (region == nil) then return false;
   else return ((cell.x >= region.topleft.x) and (cell.x <= (region.topleft.x + region.w)) and
		   (cell.y >= region.topleft.y) and (cell.y <= (region.topleft.y + region.h)));
   end
end

function is_one_of(cell, cell_list)
   for i,v in ipairs(cell_list) do
      if (v.x == cell.x and v.y == cell.y) then return true; end
   end
   return false;
end

function remove_deadend(i, j, region)
   local current_cell = {x=i, y=j};
   local intersected = false;
   local random_dir = random_carving_direction(i, j);
   local current_tries = 0;

   invalidated_cells = {};

   repeat
      current_tries = current_tries + 1;
      -- -- -- --
      -- 3: Go in a random direction from current_cell
      -- -- -- --
      if ((fDIRECTION_BIAS*100) >= math.random(1,100)) then
	     random_dir = random_carving_direction(current_cell.x, current_cell.y);
      end

      adjacent_cell = cell_in_direction(current_cell, random_dir);
      validity = cell_exists(adjacent_cell) and (not (is_in(adjacent_cell, region))) and not ((is_one_of(adjacent_cell, invalidated_cells)));

      -- -- -- --
      -- 4: Create corridor to valid neighbor
      -- -- -- --
      if (validity == true) then
	     current_tries = 0;

	     --intersection test
	     if (count(aaWALLS[adjacent_cell.x][adjacent_cell.y], true) < 4) then intersected = true; end

		 --build corridor
		 aaWALLS[current_cell.x][current_cell.y][random_dir] = false;
         aaWALLS[adjacent_cell.x][adjacent_cell.y][opposite_direction(random_dir)] = false;
	     mark_visited(adjacent_cell);
	     current_cell = adjacent_cell;

		 --invalidate this cell so that you cant' bend back into it
		 table.insert(invalidated_cells, adjacent_cell);
	  else
	     --failing too hard?
		 if (current_tries > 50) then return false; end

      end

   until (intersected == true)
   return true;
end

function add_loops()
   --scan all cells to find dead-ends
   for i,v in ipairs(aaWALLS) do
      for i2,v2 in ipairs(v) do
	     if (count(v2, true) == 3) then
		    if ((fLOOP_PARAMETER*100) >= math.random(1, 100)) then
			   remove_deadend(i, i2);
			end
		 end
	  end
   end
end

function adjacent_to_corridor(i, j)
   --look at all four adjacencies
   for k=1,4 do
      local adj_cell = cell_in_direction({x=i,y=j}, k);
	  if (cell_exists(adj_cell)) then
	     for w=1,4 do
   	        if (aaWALLS[adj_cell.x][adj_cell.y][w] == false) then return true; end
	     end
	  end
   end
   return false;
end

function overlaps_a_corridor(i, j)
   if (cell_exists({x=i,y=j})) then
      for w=1,4 do
         if (aaWALLS[i][j][w] == false) then return true; end
      end
   end
   return false;
end

function overlaps_a_room(i,j)
   return false;
end

function is_valid_room(room)
   return (room.x > 0 and room.y > 0 and room.x+room.w < iDUNGEON_WIDTH and room.y+room.h < iDUNGEON_HEIGHT);
end

function add_room()

   --generate room size
   local room_width =  math.random(iMIN_ROOM_WIDTH, iMAX_ROOM_WIDTH);
   local room_height =  math.random(iMIN_ROOM_HEIGHT, iMAX_ROOM_HEIGHT);

   local best_score = 999999999;
   local best_cell = {x=1, y=1};

   --scan all cells
   for i=1,#aaWALLS,room_width do
      for i2=1,#aaWALLS[i],room_height do
	     if (is_valid_room({x=i, y=i2, w=room_width, h=room_height}) and count(aaWALLS[i][i2],true)>1) then
	        current_score = 0;
		    --loop over this room
		    for ri=i,(i+room_width) do
   		       for rj=i2,(i2+room_height) do
			      if (adjacent_to_corridor(ri,rj)) then current_score = current_score + 50; end
			      if (overlaps_a_corridor(ri,rj)) then current_score = current_score + 120; end
			   end
		    end
		    if (current_score < best_score) then best_score = current_score; best_cell = {x=i,y=i2}; end
	     end
      end
   end

   --carve out the room
   for ri=best_cell.x, best_cell.x+room_width do
      for rj=best_cell.y, best_cell.y+room_height do
	     if (ri==best_cell.x and rj==best_cell.y) then
		    aaWALLS[ri][rj][2] = false;
			aaWALLS[ri][rj][3] = false;
		 elseif (ri==best_cell.x and rj < (best_cell.y+room_height)) then
		    aaWALLS[ri][rj][2] = false;
			aaWALLS[ri][rj][3] = false;
		    aaWALLS[ri][rj][4] = false;
		 elseif (ri==best_cell.x and rj==(best_cell.y+room_height)) then
			aaWALLS[ri][rj][3] = false;
		    aaWALLS[ri][rj][4] = false;
		 elseif (ri<(best_cell.x+room_width) and rj==(best_cell.y+room_height)) then
		    aaWALLS[ri][rj][1] = false;
			aaWALLS[ri][rj][3] = false;
		    aaWALLS[ri][rj][4] = false;
		 elseif (ri==(best_cell.x+room_width) and rj==(best_cell.y+room_height)) then
		    aaWALLS[ri][rj][1] = false;
		    aaWALLS[ri][rj][4] = false;
		 elseif (ri==(best_cell.x+room_width) and rj>(best_cell.y) and rj<(best_cell.y+room_height)) then
		    aaWALLS[ri][rj][1] = false;
			aaWALLS[ri][rj][2] = false;
		    aaWALLS[ri][rj][4] = false;
		 elseif (ri==(best_cell.x+room_width) and rj==(best_cell.y)) then
		    aaWALLS[ri][rj][1] = false;
		    aaWALLS[ri][rj][2] = false;
		 elseif (ri>(best_cell.x) and ri<(best_cell.x+room_width) and rj==(best_cell.y)) then
		    aaWALLS[ri][rj][1] = false;
			aaWALLS[ri][rj][2] = false;
		    aaWALLS[ri][rj][3] = false;
		 else
		    aaWALLS[ri][rj][1] = false;
			aaWALLS[ri][rj][2] = false;
			aaWALLS[ri][rj][3] = false;
		    aaWALLS[ri][rj][4] = false;
		 end
	  end
   end

   --pick random wall tile and digout towards a corridor
   local rand_room_cell;
   repeat
      rand_room_cell = {x=math.random(best_cell.x, best_cell.x+room_width), y=math.random(best_cell.y,best_cell.y+room_height)};
   until (count(aaWALLS[rand_room_cell.x][rand_room_cell.y], true) > 0
           and remove_deadend(rand_room_cell.x, rand_room_cell.y, {topleft = best_cell, w = room_width, h = room_height}))

   --dig it


end

function has_carvable_direction(cell)
   local adj_cell;
   for w=1,4 do
      adj_cell = cell_in_direction(cell, w);
      if (cell_exists(adj_cell) and (count(aaWALLS[adj_cell.x][adj_cell.y], true) > 0)) then
	     return true;
	   end
   end
   return false;
end

function connectify()

end

function build_new_dungeon()

--memory leak fix:
--build local aawalls copy
--use aawalls as function call each step of the way
--return local copy

   --build the maze
   gen_maze();

   --sparsify
   for i=1,iSPARSENESS do
      sparsify();
   end

   --loopify
   add_loops();

   --add rooms
   for i=1,math.random(iMIN_ROOMS, iMAX_ROOMS) do
      add_room();
   end

   return aaWALLS;
end
