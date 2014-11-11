--//left down right up
CHOICE_POINT_4 = {0.32, 0, 0.68, 0};
CHOICE_POINT_5 = {0, 0.4189, 05811, 0};
CHOICE_POINT_6 = {0.5135, 0.4865, 0, 0};
CHOICE_POINT_7 = {0, 0.3288, 0.6712, 0};
CHOICE_POINT_8 = {0, 0, 0.4366, 0.5634};
CHOICE_POINT_9 = {0, 0.5890, 0.4110, 0};
CHOICE_POINT_10 = {0.5070, 0, 0.4930, 0};
CHOICE_POINT_11 = {0.4571, 0, 0, 0.5429};
CHOICE_POINT_12 = {0, 0, 0.5352, 0.4648};
CHOICE_POINT_13 = {0, 0.5714, 0, 0.4286};
CHOICE_POINT_14 = {0.4571, 0.5429, 0, 0};
CHOICE_POINT_15 = {0.4638, 0, 0, 0.5362};
CHOICE_POINT_16 = {0, 0.2143, 0.5143, 0.2714};
CHOICE_POINT_17 = {0.2174, 0, 0.3043, 0.4783};
CHOICE_POINT_18 = {0.4328, 0.1791, 0, 0.3881};
CHOICE_POINT_19 = {0.3099, 0.5352, 0.1549, 0};


function roll_biased_dice(choice_point)

   local die_faces = {};

   local rand = (math.random(1, 100))/100;

   local cdf = {};

   --collect die faces
   for i,v in pairs(choice_point) do
      table.insert(die_faces, v);
      table.insert(cdf, v);
      if (#cdf > 1) then cdf[#cdf] = cdf[#cdf] + cdf[#cdf-1]; end
   end

   --use the cdf and rand to 'roll dice'
   for i,v in ipairs(cdf) do
      if (rand <= v) then return i; end
   end

end

function get_direction_to(A, B)
   --returns the direction required to get from A to B
   if (A.x > B.x) then return 1;
   elseif (A.x < B.x) then return 3;
   elseif (A.y > B.y) then return 4;
   elseif (A.y < B.y) then return 2;
   end
end

function find_path(A, B, dungeon)
   --return a direction to travel along a path from A to B
   if (A == nil or B == nil) then return nil; end
   local path = bfs(A, B, dungeon);

   --take next-to-last entry in path is first step
   if not (path == nil) then
      return get_direction_to(A, path[#path-1].node);
   else return nil;
   end
end

function direction_picker()
   local open_dirs = {false, false, false, false};
   local direction;

   for i,v in ipairs(aAGENT.DUNGEON[aAGENT.POSITION.x][aAGENT.POSITION.y]) do
      if not (v) then open_dirs[i] = true; end
   end

   repeat
      direction = math.random(1,4);
   until open_dirs[direction] == true;

   return direction;
end

function run_beleivable_movement_system()

   local chosen_direction = 0;


   if ((not aAGENT.hasKEY) and (aAGENT.seesKEY)) then chosen_direction = find_path(aAGENT.POSITION, aAGENT.DUNGEON.KEY_LOCATION, aAGENT.DUNGEON);
   elseif ((aAGENT.hasKEY) and (aAGENT.seesEXIT) and ((aAGENT.DUNGEON.crystals/aAGENT.DUNGEON.total_squares) > 0.70)) then chosen_direction = find_path(aAGENT.POSITION, aAGENT.DUNGEON.EXIT_LOCATION, aAGENT.DUNGEON);
   elseif (aAGENT.GAZE) then chosen_direction = find_path(aAGENT.POSITION, aAGENT.CHOSEN_DARKWAY, aAGENT.DUNGEON);
   else
      local cdir = ai();
	  if (cdir == false) then chosen_direction = find_path(aAGENT.POSITION, aAGENT.CHOSEN_DARKWAY, aAGENT.DUNGEON);
	  else chosen_direction = cdir; end
   end

   return chosen_direction;

end


-- 1. pick an initial direction

-- 2. keep going in that direction until a decision point is found
-- -- -- a. check out the situation
-- -- -- -- -- i. consider only unexplored paths
-- -- -- b. is it a decision point?

-- 3. evaluate the decision point and decide

-- 4. If dead end, then goto the nearest darkway point.

-- 5. If all darkways are gone, then end.

function get_on_track()

   if (not aAGENT.GAZE) then
      -- go to first nearest darkway
	  aAGENT.CHOSEN_DARKWAY = get_closest_darkway();
	  aAGENT.GAZE = true;
	  return find_path(aAGENT.POSITION, aAGENT.CHOSEN_DARKWAY, aAGENT.DUNGEON);
   else return false;
   end
end

function ai()
   local chosen_direction = 0;

   --open dirs indicate paths we can take
   local open_dirs = {false, false, false, false};

   --closed dirs are paths we could take, but have been explored
   local closed_dirs = {false, false, false, false};

   --dark paths
   local dark_dirs = {open_dirs[1] and closed_dirs[1], open_dirs[2] and closed_dirs[2], open_dirs[3] and closed_dirs[3], open_dirs[4] and closed_dirs[4]};

   --populate open and closed lists
   for i,v in ipairs(aAGENT.DUNGEON[aAGENT.POSITION.x][aAGENT.POSITION.y]) do
      if not (v) then
         open_dirs[i] = true;
         c = cell_in_direction(aAGENT.POSITION, i);
	     if not (aAGENT.DUNGEON.PELLETS[c.x][c.y]) then closed_dirs[i] = true; end
      end
   end

   --if you need to get on track
   if ((not open_dirs[1] or (open_dirs[1] and closed_dirs[1])) and
        (not open_dirs[2] or (open_dirs[2] and closed_dirs[2])) and
		 (not open_dirs[3] or (open_dirs[3] and closed_dirs[3])) and
		  (not open_dirs[4] or (open_dirs[4] and closed_dirs[4])) and
		   (not aAGENT.GAZE)) then
      return get_on_track();
   end


   --different combinations of open and closed:
   if ((not open_dirs[1]) and (not open_dirs[2]) and (not open_dirs[3]) and (not open_dirs[4])) then
      --cannot go anywhere
      chosen_direction = 0;

   elseif ((open_dirs[1]) and (not open_dirs[2]) and (not open_dirs[3]) and (not open_dirs[4])) then
      --only way to go is left
	  chosen_direction = 1;

   elseif ((not open_dirs[1]) and (open_dirs[2]) and (not open_dirs[3]) and (not open_dirs[4])) then
      --only way to go is down
	  chosen_direction = 2;

   elseif ((not open_dirs[1]) and (not open_dirs[2]) and (open_dirs[3]) and (not open_dirs[4])) then
      --only way to go is right
	  chosen_direction = 3;

   elseif ((not open_dirs[1]) and (not open_dirs[2]) and (not open_dirs[3]) and (open_dirs[4])) then
      --only way to go is up
	  chosen_direction = 4;

   elseif ((open_dirs[1]) and (open_dirs[2]) and (not open_dirs[3]) and (not open_dirs[4])) then
      --can go left or down
	  if ((closed_dirs[1]) and (closed_dirs[2])) then return get_on_track(); end
	  if ((closed_dirs[1])) then return 2; end
	  if ((closed_dirs[2])) then return 1; end

	  if (aAGENT.DIRECTION == 3) then chosen_direction = 2;
	  elseif (aAGENT.DIRECTION == 4) then chosen_direction = 1;
	  else chosen_direction = 2; end

   elseif ((open_dirs[1]) and (not open_dirs[2]) and (open_dirs[3]) and (not open_dirs[4])) then
      --can go left or right
	  if ((closed_dirs[1]) and (closed_dirs[3])) then return get_on_track(); end
	  if ((closed_dirs[1])) then return 3; end
	  if ((closed_dirs[3])) then return 1; end

	  if (aAGENT.DIRECTION == 1) then chosen_direction = 1;
	  elseif (aAGENT.DIRECTION == 3) then chosen_direction = 3;
	  else chosen_direction = 1; end

   elseif ((open_dirs[1]) and (not open_dirs[2]) and (not open_dirs[3]) and (open_dirs[4])) then
      --can go left or up
	  if ((closed_dirs[1]) and (closed_dirs[4])) then return get_on_track(); end
	  if ((closed_dirs[1])) then return 4; end
	  if ((closed_dirs[4])) then return 1; end

	  if (aAGENT.DIRECTION == 3) then chosen_direction = 4;
	  elseif (aAGENT.DIRECTION == 2) then chosen_direction = 1;
	  else chosen_direction = 4; end


   elseif ((not open_dirs[1]) and (open_dirs[2]) and (open_dirs[3]) and (not open_dirs[4])) then
      --can go down or right
	  if ((closed_dirs[2]) and (closed_dirs[3])) then return get_on_track(); end
	  if ((closed_dirs[2])) then return 3; end
	  if ((closed_dirs[3])) then return 2; end

	  if (aAGENT.DIRECTION == 4) then chosen_direction = 3;
	  elseif (aAGENT.DIRECTION == 1) then chosen_direction = 2;
	  else chosen_direction = 3; end

   elseif ((not open_dirs[1]) and (open_dirs[2]) and (not open_dirs[3]) and (open_dirs[4])) then
      --can go down or up
	  if ((closed_dirs[2]) and (closed_dirs[4])) then return get_on_track(); end
	  if ((closed_dirs[2])) then return 4; end
	  if ((closed_dirs[4])) then return 2; end

	  if (aAGENT.DIRECTION == 2) then chosen_direction = 2;
	  elseif (aAGENT.DIRECTION == 4) then chosen_direction = 4;
	  else chosen_direction = 4; end

   elseif ((not open_dirs[1]) and (not open_dirs[2]) and (open_dirs[3]) and (open_dirs[4])) then
      --can go right or up
	  if ((closed_dirs[3]) and (closed_dirs[4])) then return get_on_track(); end
	  if ((closed_dirs[3])) then return 4; end
	  if ((closed_dirs[4])) then return 3; end

	  if (aAGENT.DIRECTION == 2) then chosen_direction = 3;
	  elseif (aAGENT.DIRECTION == 1) then chosen_direction = 4;
	  else chosen_direction = 3; end

   elseif ((open_dirs[1]) and (open_dirs[2]) and (open_dirs[3]) and (not open_dirs[4])) then
      --can go left or down or right
	  if ((closed_dirs[1]) and (closed_dirs[2]) and (closed_dirs[3])) then return get_on_track(); end
	  if ((closed_dirs[1]) and (closed_dirs[2])) then return 3; end
	  if ((closed_dirs[1]) and (closed_dirs[3])) then return 2; end
	  if ((closed_dirs[2]) and (closed_dirs[3])) then return 1; end

	  if (aAGENT.DIRECTION == 1) then chosen_direction = roll_biased_dice(CHOICE_POINT_6);
	  elseif (aAGENT.DIRECTION == 3) then chosen_direction = roll_biased_dice(CHOICE_POINT_5);
	  elseif (aAGENT.DIRECTION == 4) then chosen_direction = roll_biased_dice(CHOICE_POINT_4);
	  else chosen_direction = 1; end

   elseif ((open_dirs[1]) and (not open_dirs[2]) and (open_dirs[3]) and (open_dirs[4])) then
      --can go left or right or up
	  if ((closed_dirs[1]) and (closed_dirs[3]) and (closed_dirs[4])) then return get_on_track(); end
	  if ((closed_dirs[1]) and (closed_dirs[3])) then return 4; end
	  if ((closed_dirs[1]) and (closed_dirs[4])) then return 3; end
	  if ((closed_dirs[3]) and (closed_dirs[4])) then return 1; end


	  if (aAGENT.DIRECTION == 1) then chosen_direction = roll_biased_dice(CHOICE_POINT_11);
	  elseif (aAGENT.DIRECTION == 3) then chosen_direction = roll_biased_dice(CHOICE_POINT_12);
	  elseif (aAGENT.DIRECTION == 2) then chosen_direction = roll_biased_dice(CHOICE_POINT_10);
	  else chosen_direction = 1; end

   elseif ((not open_dirs[1]) and (open_dirs[2]) and (open_dirs[3]) and (open_dirs[4])) then
      --can go down or right or up
	  if ((closed_dirs[2]) and (closed_dirs[3]) and (closed_dirs[4])) then return get_on_track(); end
	  if ((closed_dirs[2]) and (closed_dirs[3])) then return 4; end
	  if ((closed_dirs[2]) and (closed_dirs[4])) then return 3; end
	  if ((closed_dirs[3]) and (closed_dirs[4])) then return 2; end

	  if (aAGENT.DIRECTION == 1) then chosen_direction = roll_biased_dice(CHOICE_POINT_7);
	  elseif (aAGENT.DIRECTION == 2) then chosen_direction = roll_biased_dice(CHOICE_POINT_9);
	  elseif (aAGENT.DIRECTION == 4) then chosen_direction = roll_biased_dice(CHOICE_POINT_8);
	  else chosen_direction = 2; end

   elseif ((open_dirs[1]) and (open_dirs[2]) and (not open_dirs[3]) and (open_dirs[4])) then
      --can go left or down or up
	  if ((closed_dirs[1]) and (closed_dirs[2]) and (closed_dirs[4])) then return get_on_track(); end
	  if ((closed_dirs[1]) and (closed_dirs[2])) then return 4; end
	  if ((closed_dirs[1]) and (closed_dirs[4])) then return 2; end
	  if ((closed_dirs[2]) and (closed_dirs[4])) then return 1; end

	  if (aAGENT.DIRECTION == 2) then chosen_direction = roll_biased_dice(CHOICE_POINT_14);
	  elseif (aAGENT.DIRECTION == 3) then chosen_direction = roll_biased_dice(CHOICE_POINT_13);
	  elseif (aAGENT.DIRECTION == 4) then chosen_direction = roll_biased_dice(CHOICE_POINT_15);
	  else chosen_direction = 1; end

   elseif ((open_dirs[1]) and (open_dirs[2]) and (open_dirs[3]) and (open_dirs[4])) then
      --can go anywhere
	  if ((closed_dirs[1]) and (closed_dirs[2]) and (closed_dirs[3]) and (closed_dirs[4])) then return get_on_track(); end

	  if (aAGENT.DIRECTION == 1) then chosen_direction = roll_biased_dice(CHOICE_POINT_18);
	  elseif (aAGENT.DIRECTION == 2) then chosen_direction = roll_biased_dice(CHOICE_POINT_19);
	  elseif (aAGENT.DIRECTION == 3) then chosen_direction = roll_biased_dice(CHOICE_POINT_16);
	  elseif (aAGENT.DIRECTION == 4) then chosen_direction = roll_biased_dice(CHOICE_POINT_17);
	  else chosen_direciton = 1; end
   end

   if (chosen_direction == 0) then chosen_direction = direction_picker(); end

   return chosen_direction;
end
