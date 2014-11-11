function love.load()

   --Agent Player
   aAGENT = {};
   aAGENT.POSITION = {};
   aAGENT.hasKEY = false;
   aAGENT.seesKEY= false;
   aAGENT.seesEXIT = false;
   aAGENT.atEXIT = false;
   aAGENT.DUNGEON = {};
   aAGENT.DUNGEON.EXPLORED = {};
   aAGENT.DUNGEON.KEY_LOCATION = {};
   aAGENT.DUNGEON.EXIT_LOCATION = {};
   aAGENT.DUNGEON.DARKWAYS = {};
   aAGENT.CHOSEN_DARKWAY = 0;
   aAGENT.DIRECTION = 1;
   aAGENT.score = 0;
   aAGENT.level = 0;
   aAGENT.DUNGEON.PELLETS = {};
   aAGENT.face = 1;
   aAGENT.GAZE = false;
   aAGENT.DUNGEON.total_squares = 0;
   aAGENT.DUNGEON.crystals = 0;

   --Human Player
   aHUMAN = {};
   aHUMAN.POSITION = {};
   aHUMAN.hasKEY = false;
   aHUMAN.seesKEY = false;
   aHUMAN.seesEXIT = false;
   aHUMAN.atEXIT = false;
   aHUMAN.DUNGEON = {};
   aHUMAN.DUNGEON.EXPLORED = {};
   aHUMAN.DUNGEON.KEY_LOCATION = {};
   aHUMAN.DUNGEON.EXIT_LOCATION = {};
   aHUMAN.score = 0;
   aHUMAN.level = 0;
   aHUMAN.DUNGEON.PELLETS = {};
   aHUMAN.face = 1;
   aHUMAN.DUNGEON.total_squares = 0;
   aHUMAN.DUNGEON.crystals = 0;

   --HUman Stats
   total_time_played = 0;
   keystrokes = 0;
   movesmade = 0;

   GAME_OVER = false;
   game_active = false;
   iWINNER = 0;

   --Game Mode
   game_length = 0; --in seconds
   time_remaining = 360; --in seconds

   --Window Controller
   window = 1; --1 = launch screen
		      -- 2 high score screen
		      statwindow = false;

   --Menu Selectors
   selector1 = 1;
   selector2 = 1;
   selector3 = 1;
   selector4 = 1;
   selector5 = 1;

   --recordbook
   GAME_DATA = {};
   GAME_DATA.games_played = 0;
   GAME_DATA.game_time = 0;
   GAME_DATA.total_score = 0;
   GAME_DATA.total_score_agent = 0;
   GAME_DATA.total_min_room_height = 0;
   GAME_DATA.total_max_room_height = 0;
   GAME_DATA.total_min_room_width = 0;
   GAME_DATA.total_max_room_width = 0;
   GAME_DATA.total_min_rooms = 0;
   GAME_DATA.total_max_rooms = 0;
   GAME_DATA.total_sparseness = 0;
   GAME_DATA.total_selector4 = 0;
   GAME_DATA.total_loop = 0;
   GAME_DATA.total_level = 0;
   GAME_DATA.total_level_agent = 0;

   --love.update stuff
   fELAPSED = 0;
   fDAY_LENGTH = 0.0018;
   fELAPSED_HUMAN = 0;
   fDAY_LENGTH_HUMAN = 0.0033;

   crystalalpha = 200;
   car_x = 1;

   left_key_depressed = false;
   down_key_depressed = false;
   right_key_depressed = false;
   up_key_depressed = false;

   -- -- -- -- -- -- -- -- -- -- -- --
   -- Some dungeon generation parameters (Defaults)
   -- -- -- -- -- -- -- -- -- -- -- --
   fDIRECTION_BIAS = 0.05; --Rate at which corridors turn
   iSPARSENESS =  12;      --Number of times sparsify is ran
   fLOOP_PARAMETER = 1.00; --Rate at which deadends are turned into loops

   -- -- -- -- -- -- -- -- -- -- -- --
   -- Room Specification Parameters
   iMIN_ROOM_WIDTH = 3;
   iMAX_ROOM_WIDTH = 7;
   iMIN_ROOM_HEIGHT = 3;
   iMAX_ROOM_HEIGHT = 8;
   iMIN_ROOMS = 3;
   iMAX_ROOMS = 8;



   -- -- -- -- -- -- -- -- -- -- -- --
   -- Start with a new random dungeon
   -- -- -- -- -- -- -- -- -- -- -- --

   require 'random_dungeon_gen_core';





   require 'bfs';

   require 'believable_mover';

   require 'graphics';

   bgm1 = love.audio.newSource("bgm/jiggywithit.mp3", "stream");
   bgm1:setLooping(true);
   bgm1:setVolume(0.45);
   --bgm2 = love.audio.newSource("bgm/darkandlight.mp3", "stream");
   --bgm2:setLooping(true);
   --bgm2:setVolume(0.40);

   --initial music
   love.audio.play(bgm1);

   sfx1 = love.audio.newSource("sfx/sfx1.mp3", "static"); --menu cursor
   sfx2 = love.audio.newSource("sfx/sfx2.mp3", "static"); --collect crystal
   sfx3 = love.audio.newSource("sfx/sfx3.mp3", "static"); --levelcomplete
   sfx4 = love.audio.newSource("sfx/sfx4.mp3", "static"); --collectkey

   --randomizer
   math.randomseed(os.time());



end

function random_dungeon_params()
   --Randomize Dungeon Parameters
   fDIRECTION_BIAS = 0.05; --Rate at which corridors turn
   iSPARSENESS =  math.random(1, 15);      --Number of times sparsify is ran
   fLOOP_PARAMETER = math.random(0.001, 0.999); --Rate at which deadends are turned into loops

   -- -- -- -- -- -- -- -- -- -- -- --
   -- Room Specification Parameters
   if (iSPARSENESS > 10) then
	   iMIN_ROOM_WIDTH = 3;
	   iMAX_ROOM_WIDTH = 7;
	   iMIN_ROOM_HEIGHT = 3;
	   iMAX_ROOM_HEIGHT = 8;
	   iMIN_ROOMS = 3;
	   iMAX_ROOMS = 8;
   elseif (iSPARSENESS > 5) then
       iMIN_ROOM_WIDTH = 3;
	   iMAX_ROOM_WIDTH = 5;
	   iMIN_ROOM_HEIGHT = 3;
	   iMAX_ROOM_HEIGHT = 5;
	   iMIN_ROOMS = 2;
	   iMAX_ROOMS = 5;
   else
       iMIN_ROOM_WIDTH = 2;
	   iMAX_ROOM_WIDTH = 3;
	   iMIN_ROOM_HEIGHT = 2;
	   iMAX_ROOM_HEIGHT = 3;
	   iMIN_ROOMS = 1;
	   iMAX_ROOMS = 3;
   end
end

function love.update(dt)

   -- -- -- -- -- -- -- -- -- -- -- --
   -- Agent moves every so often
   -- -- -- -- -- -- -- -- -- -- -- --

   --collect elapsed time
   if (game_active) then

      fELAPSED = fELAPSED + dt;
	  fELAPSED_HUMAN = fELAPSED_HUMAN + dt;

	   --only do if entire day elapsed
	   if (fELAPSED > fDAY_LENGTH) and not (GAME_OVER) then
	      fELAPSED = 0;
		  --[[if not (aAGENT.hasKEY and aAGENT.seesEXIT) then
		     random_move();
		  else
		     move_to(aAGENT.DUNGEON.EXIT_LOCATION);
		  end--]]

		  local move_dir = run_beleivable_movement_system();

		  if (move_dir == 0) then move_dir = direction_picker(); end

		  if (move_dir == 1) then aAGENT.POSITION.x = aAGENT.POSITION.x - 1; aAGENT.face = 1;
		  elseif (move_dir == 2) then aAGENT.POSITION.y = aAGENT.POSITION.y + 1; aAGENT.face = 2;
		  elseif (move_dir == 3) then aAGENT.POSITION.x = aAGENT.POSITION.x + 1; aAGENT.face = 3;
		  elseif (move_dir == 4) then aAGENT.POSITION.y = aAGENT.POSITION.y - 1; aAGENT.face = 4; end

		  aAGENT.DIRECTION = move_dir;

		  agent_explore();

		  if (aAGENT.CHOSEN_DARKWAY ~= nil) then
   		     if (aAGENT.GAZE and match(aAGENT.POSITION, aAGENT.CHOSEN_DARKWAY)) then aAGENT.GAZE = false; end
		  end

	   end

	   --updates for being at the key or exit
	   if (match(aAGENT.POSITION, aAGENT.DUNGEON.KEY_LOCATION) and not aAGENT.hasKEY) then
		  aAGENT.hasKEY = true;
		  aAGENT.score = aAGENT.score + 500;
	   end

	   if (match(aAGENT.POSITION, aAGENT.DUNGEON.EXIT_LOCATION)) then
		  aAGENT.atEXIT = true;
	   else
		  aAGENT.atEXIT = false;
	   end

	   --check for win
	   if (aAGENT.hasKEY and aAGENT.atEXIT and ((aAGENT.DUNGEON.crystals/aAGENT.DUNGEON.total_squares) > 0.70)) then
		  aAGENT.score = aAGENT.score + 1000;
		  aAGENT.level = aAGENT.level + 1;
		  build_agent_dungeon();
	   end
   end


   if (time_remaining > 0 and game_active) then time_remaining = time_remaining - dt;
   elseif (time_remaining <= 0 and game_active) then
      game_active = false;
	  GAME_DATA.games_played = GAME_DATA.games_played + 1;
	  GAME_DATA.game_time = GAME_DATA.game_time + game_length;
	  GAME_DATA.total_score = GAME_DATA.total_score + aHUMAN.score;
	  GAME_DATA.total_score_agent = GAME_DATA.total_score_agent + aAGENT.score;
	  GAME_DATA.total_min_room_height = GAME_DATA.total_min_room_height + iMIN_ROOM_HEIGHT;
	  GAME_DATA.total_max_room_height = GAME_DATA.total_max_room_height + iMAX_ROOM_HEIGHT;
	  GAME_DATA.total_min_room_width = GAME_DATA.total_min_room_width + iMIN_ROOM_WIDTH;
	  GAME_DATA.total_max_room_width = GAME_DATA.total_max_room_width + iMAX_ROOM_WIDTH;
	  GAME_DATA.total_min_rooms = GAME_DATA.total_min_rooms + iMIN_ROOMS;
	  GAME_DATA.total_max_rooms = GAME_DATA.total_max_rooms + iMAX_ROOMS;
	  GAME_DATA.total_sparseness = GAME_DATA.total_sparseness + iSPARSENESS;
	  GAME_DATA.total_selector4 = GAME_DATA.total_selector4 + selector4;
	  GAME_DATA.total_loop = GAME_DATA.total_loop + fLOOP_PARAMETER;
	  GAME_DATA.total_level = GAME_DATA.total_level + aHUMAN.level;
	  GAME_DATA.total_level_agent = GAME_DATA.total_level_agent + aAGENT.level;
	  file = io.open ("data2.txt", "a");
	  file:write(
	     os.date()..", "..
		 GAME_DATA.games_played..", "..
		 GAME_DATA.game_time..", "..
		 aHUMAN.score..", "..
		 aAGENT.score..", "..
		 selector4..", "..
		 iSPARSENESS..", "..
		 fLOOP_PARAMETER..", "..
		 iMIN_ROOM_HEIGHT..", "..
		 iMAX_ROOM_HEIGHT..", "..
		 iMIN_ROOM_WIDTH..", "..
		 iMAX_ROOM_WIDTH..", "..
		 iMIN_ROOMS..", "..
		 iMAX_ROOMS..", "..
		 aHUMAN.level..", "..
		 aAGENT.level..", "..
		 GAME_DATA.total_score..", "..
		 GAME_DATA.total_score_agent..", "..
		 GAME_DATA.total_min_room_height..", "..
		 GAME_DATA.total_max_room_height..", "..
		 GAME_DATA.total_min_room_width..", "..
		 GAME_DATA.total_max_room_width..", "..
		 GAME_DATA.total_min_rooms..", "..
		 GAME_DATA.total_max_rooms..", "..
		 GAME_DATA.total_sparseness..", "..
		 GAME_DATA.total_selector4..", "..
		 GAME_DATA.total_loop..", "..
		 keystrokes..", "..
		 movesmade..", "..
		 total_time_played..", "..
		 GAME_DATA.total_level..", "..
		 GAME_DATA.total_level_agent..", "..
		 "\n");
	  io.close(file);

	  os.execute("data2.txt")


   end

   --update play time!
   total_time_played = total_time_played + dt;

   --crystal alpha
   crystalalpha = crystalalpha + 20;

   --car animation on title
   car_x = car_x + 12;
   if (car_x > 1200) then car_x = 1; end

   if (crystalalpha > 510) then crystalalpha = 0; end

   if (fELAPSED_HUMAN > fDAY_LENGTH_HUMAN) then
      fELAPSED_HUMAN = 0;
      --key move presses
      if (window == 4) then
         if (love.keyboard.isDown("left") and not (love.keyboard.isDown("right"))) then move_in_direction(1); aHUMAN.face = 1; end
	     if (love.keyboard.isDown("down") and not (love.keyboard.isDown("up"))) then move_in_direction(2); aHUMAN.face = 2; end
	     if (love.keyboard.isDown("right") and not (love.keyboard.isDown("left"))) then move_in_direction(3); aHUMAN.face = 3; end
	     if (love.keyboard.isDown("up") and not (love.keyboard.isDown("down"))) then move_in_direction(4); aHUMAN.face = 4; end
      end
   end
end

function move_to(location)
   local path = bfs(aAGENT.POSITION, location);

   --take next-to-last entry in path is first step
   if not (path == nil) then
      aAGENT.POSITION = path[#path-1].node;
	  agent_explore();
   end

end

function random_move()
   if (#aAGENT.DUNGEON.DARKWAYS > 0) then
      --chose a darkway
	  aAGENT.CHOSEN_DARKWAY = get_closest_darkway();
      move_to(aAGENT.CHOSEN_DARKWAY);
   end
end

function get_closest_darkway()
   local function distance(A, B)
      --Utility Function calculates euclidean distance between two objects
      return math.sqrt((A.x - B.x)^2 + (A.y - B.y)^2);
   end

   local min_distance = 999999999;
   local min_index = 1;
   for i,v in ipairs(aAGENT.DUNGEON.DARKWAYS) do
      local len = (distance(aAGENT.POSITION, v) - math.random(0, 2));
      if (len < min_distance) then min_distance = len; min_index = i;
	  elseif (len == min_distance) then if (math.random(1,100) > 50) then min_distance = len; min_index = i; end
	  end
   end
   return aAGENT.DUNGEON.DARKWAYS[min_index];
end

function get_min(list)
   local min = 999999999;
   local index = 1;
   for i,v in ipairs(list) do
      if (v < min) then min = v; index = i; end
   end
   return index;
end

function move_in_direction(dir)
   -- -- -- -- -- -- -- -- -- -- -- --
   -- Move the Human in certain direction
   -- -- -- -- -- -- -- -- -- -- -- --
   if (dir == 1) then
      if (cell_exists(cell_in_direction(aHUMAN.POSITION, 1)) and aHUMAN.DUNGEON[aHUMAN.POSITION.x][aHUMAN.POSITION.y][1] == false) then
	     aHUMAN.POSITION.x = aHUMAN.POSITION.x - 1;
	     movesmade = movesmade+1;
		 aHUMAN.face = 1;
	  end
   end

   if (dir == 2) then
      if (cell_exists(cell_in_direction(aHUMAN.POSITION, 2)) and aHUMAN.DUNGEON[aHUMAN.POSITION.x][aHUMAN.POSITION.y][2] == false) then
	     aHUMAN.POSITION.y = aHUMAN.POSITION.y + 1;
	     movesmade = movesmade+1;
		 aHUMAN.face = 2;
	  end
   end

   if (dir == 3) then
      if (cell_exists(cell_in_direction(aHUMAN.POSITION, 3)) and aHUMAN.DUNGEON[aHUMAN.POSITION.x][aHUMAN.POSITION.y][3] == false) then
	     aHUMAN.POSITION.x = aHUMAN.POSITION.x + 1;
	     movesmade = movesmade+1;
		 aHUMAN.face = 3;
	  end
   end

   if (dir == 4) then
      if (cell_exists(cell_in_direction(aHUMAN.POSITION, 4)) and aHUMAN.DUNGEON[aHUMAN.POSITION.x][aHUMAN.POSITION.y][4] == false) then
	     aHUMAN.POSITION.y = aHUMAN.POSITION.y - 1;
	     movesmade = movesmade+1;
		 aHUMAN.face = 4;
	  end
   end

   --updates for being at the key or exit
   if (match(aHUMAN.POSITION, aHUMAN.DUNGEON.KEY_LOCATION) and not aHUMAN.hasKEY) then
      aHUMAN.hasKEY = true;
	  love.audio.play(sfx4);
      aHUMAN.score = aHUMAN.score + 500;
   end

   if (match(aHUMAN.POSITION, aHUMAN.DUNGEON.EXIT_LOCATION)) then
      aHUMAN.atEXIT = true;
   else
      aHUMAN.atEXIT = false;
   end

   --check for win
   if (aHUMAN.atEXIT and aHUMAN.hasKEY and ((aHUMAN.DUNGEON.crystals/aHUMAN.DUNGEON.total_squares) > 0.70)) then
      aHUMAN.score = aHUMAN.score + 1000;
	  aHUMAN.level = aHUMAN.level+1;
	  love.audio.play(sfx3);
      build_human_dungeon();
   else
      human_explore();
   end
end

function match(two, locations)
   return (two.x == locations.x and two.y == locations.y);
end

function human_explore()

   --reveal where you just stepped into
   aHUMAN.DUNGEON.EXPLORED[aHUMAN.POSITION.x][aHUMAN.POSITION.y] = true;

   --reveal visible 3x3 region around you
   for i=aHUMAN.POSITION.x-1,aHUMAN.POSITION.x+1 do
      if (i > 0 and i < iDUNGEON_WIDTH+1) then
	     if (((aHUMAN.DUNGEON[i][aHUMAN.POSITION.y][1] == false) and (i == aHUMAN.POSITION.x+1)) or ((aHUMAN.DUNGEON[i][aHUMAN.POSITION.y][3] == false) and (i == aHUMAN.POSITION.x-1))) then
	        aHUMAN.DUNGEON.EXPLORED[i][aHUMAN.POSITION.y] = true;
		 end
	  end
   end

   for i=aHUMAN.POSITION.y-1,aHUMAN.POSITION.y+1 do
      if (i > 0 and i < iDUNGEON_HEIGHT+1) then
	     if (((aHUMAN.DUNGEON[aHUMAN.POSITION.x][i][2] == false) and (i == aHUMAN.POSITION.y-1)) or ((aHUMAN.DUNGEON[aHUMAN.POSITION.x][i][4] == false) and (i == aHUMAN.POSITION.y+1))) then
		    aHUMAN.DUNGEON.EXPLORED[aHUMAN.POSITION.x][i] = true;
		 end
	  end
   end

   --pellets
   if (aHUMAN.DUNGEON.PELLETS[aHUMAN.POSITION.x][aHUMAN.POSITION.y]) then
      aHUMAN.DUNGEON.PELLETS[aHUMAN.POSITION.x][aHUMAN.POSITION.y] = false;
      aHUMAN.score = aHUMAN.score + 10;
	  aHUMAN.DUNGEON.crystals = aHUMAN.DUNGEON.crystals + 1;
	  love.audio.play(sfx2);
  end

   --updates to visibility of key and exit
   if (aHUMAN.DUNGEON.EXPLORED[aHUMAN.DUNGEON.KEY_LOCATION.x][aHUMAN.DUNGEON.KEY_LOCATION.y] == true) then
	  aHUMAN.seesKEY = true;
   end

   if (aHUMAN.DUNGEON.EXPLORED[aHUMAN.DUNGEON.EXIT_LOCATION.x][aHUMAN.DUNGEON.EXIT_LOCATION.y] == true) then
	  aHUMAN.seesEXIT = true;
   end

end


function agent_explore(ind)

   --reveal regions
   for i=aAGENT.POSITION.x-1,aAGENT.POSITION.x+1 do
      if (i > 0 and i < iDUNGEON_WIDTH+1) then
	     if (((aAGENT.DUNGEON[i][aAGENT.POSITION.y][1] == false) and (i == aAGENT.POSITION.x+1)) or ((aAGENT.DUNGEON[i][aAGENT.POSITION.y][3] == false) and (i == aAGENT.POSITION.x-1))) then
	        aAGENT.DUNGEON.EXPLORED[i][aAGENT.POSITION.y] = true;
		 end
	  end
   end

   for i=aAGENT.POSITION.y-1,aAGENT.POSITION.y+1 do
      if (i > 0 and i < iDUNGEON_HEIGHT+1) then
	     if (((aAGENT.DUNGEON[aAGENT.POSITION.x][i][2] == false) and (i == aAGENT.POSITION.y-1)) or ((aAGENT.DUNGEON[aAGENT.POSITION.x][i][4] == false) and (i == aAGENT.POSITION.y+1))) then
		    aAGENT.DUNGEON.EXPLORED[aAGENT.POSITION.x][i] = true;
		 end
	  end
   end

   --remove revealed darkways
   for i=aAGENT.POSITION.x-1,aAGENT.POSITION.x+1 do
      for j=aAGENT.POSITION.y-1,aAGENT.POSITION.y+1 do
		 for p,v in ipairs(aAGENT.DUNGEON.DARKWAYS) do
		    if (v.x == i and v.y == j) then
			   table.remove(aAGENT.DUNGEON.DARKWAYS, p);
			end
		 end
	  end
   end

   --add new darkways
   for i=aAGENT.POSITION.x-1,aAGENT.POSITION.x+1 do
      for j=aAGENT.POSITION.y-1,aAGENT.POSITION.y+1 do
	     if (i > 0 and j > 0 and i < iDUNGEON_WIDTH+1 and j < iDUNGEON_HEIGHT+1) then
		    for k=1,4 do
   		       local adj_cell = cell_in_direction({x=i, y=j}, k);
		       if (aAGENT.DUNGEON[i][j][k] == false) and (aAGENT.DUNGEON.EXPLORED[adj_cell.x][adj_cell.y] == false) and (aAGENT.DUNGEON.EXPLORED[i][j]) then
			      table.insert(aAGENT.DUNGEON.DARKWAYS, {x=i, y=j});
		       end
		    end
         end
	  end
   end

   --pellets
   if (aAGENT.DUNGEON.PELLETS[aAGENT.POSITION.x][aAGENT.POSITION.y]) then
      aAGENT.DUNGEON.PELLETS[aAGENT.POSITION.x][aAGENT.POSITION.y] = false;
      aAGENT.score = aAGENT.score + 10;
	  aAGENT.DUNGEON.crystals = aAGENT.DUNGEON.crystals + 1;
  end

   --updates to visibility of key and exit
   if (aAGENT.DUNGEON.EXPLORED[aAGENT.DUNGEON.KEY_LOCATION.x][aAGENT.DUNGEON.KEY_LOCATION.y] == true) then
	  aAGENT.seesKEY = true;
   end

   if (aAGENT.DUNGEON.EXPLORED[aAGENT.DUNGEON.EXIT_LOCATION.x][aAGENT.DUNGEON.EXIT_LOCATION.y] == true) then
	  aAGENT.seesEXIT = true;
   end
end

function build_human_dungeon()

   --cell function to get a random unused cell
   local function random_cell_human(cell) return (count(aHUMAN.DUNGEON[cell.x][cell.y], true) < 4); end

   --build a random dungeon
   repeat
      aHUMAN.DUNGEON = build_new_dungeon();
	  aHUMAN.DUNGEON.EXPLORED = {};

	  --Initialize Exploration Variables
	   for i=1,iDUNGEON_WIDTH+1 do
		  aHUMAN.DUNGEON.EXPLORED[i] = {};
		  for j=1,iDUNGEON_HEIGHT+1 do
			 aHUMAN.DUNGEON.EXPLORED[i][j] = true;
		  end
	   end

	  --Initialize Player Position
      aHUMAN.POSITION = random_cell(random_cell_human);

      --Keys and Exits; initializings
      aHUMAN.DUNGEON.KEY_LOCATION = random_cell(random_cell_human);
      aHUMAN.DUNGEON.EXIT_LOCATION = random_cell(random_cell_human);
   until (not (find_path(aHUMAN.POSITION, aHUMAN.DUNGEON.KEY_LOCATION, aHUMAN.DUNGEON)== nil) and not (find_path(aHUMAN.POSITION, aHUMAN.DUNGEON.EXIT_LOCATION, aHUMAN.DUNGEON)== nil))

   aHUMAN.hasKEY = false;
   aHUMAN.seesKEY = false;
   aHUMAN.seesEXIT = false;
   aHUMAN.atEXIT = false;

   --initalize parameters
   aHUMAN.DUNGEON.EXPLORED = {};
   aHUMAN.DUNGEON.PELLETS = {};
   aHUMAN.DUNGEON.crystals = 0;
   aHUMAN.DUNGEON.total_squares = 0;

   --Initialize Exploration Variables
   for i=1,iDUNGEON_WIDTH do
      aHUMAN.DUNGEON.EXPLORED[i] = {};
	  aHUMAN.DUNGEON.PELLETS[i] = {};
      for j=1,iDUNGEON_HEIGHT do
	     aHUMAN.DUNGEON.EXPLORED[i][j] = false;
		 aHUMAN.DUNGEON.PELLETS[i][j] = true;
		 if (count(aHUMAN.DUNGEON[i][j], true) < 4) then aHUMAN.DUNGEON.total_squares = aHUMAN.DUNGEON.total_squares + 1; end

	  end


   end

   --Initial Exploration around Player Position
   human_explore();
end

function build_agent_dungeon()

   --cell function to get a random unused cell
   local function random_cell_agent(cell) return (count(aAGENT.DUNGEON[cell.x][cell.y], true) < 4); end

   aAGENT.GAZE = false;

   --build a random dungeon
   repeat
	   aAGENT.DUNGEON = build_new_dungeon();
	   aAGENT.DUNGEON.EXPLORED = {};



	   --Initialize Exploration Variables
	   for i=1,iDUNGEON_WIDTH+1 do
		  aAGENT.DUNGEON.EXPLORED[i] = {};
		  for j=1,iDUNGEON_HEIGHT+1 do
			 aAGENT.DUNGEON.EXPLORED[i][j] = true;
		  end
	   end

	   --Initialize the Agent Position
	   aAGENT.POSITION = random_cell(random_cell_agent);

	   --Keys and Exits; initializings
	   aAGENT.DUNGEON.KEY_LOCATION = random_cell(random_cell_agent);
	   aAGENT.DUNGEON.EXIT_LOCATION = random_cell(random_cell_agent);

   until (not (find_path(aAGENT.POSITION, aAGENT.DUNGEON.KEY_LOCATION, aAGENT.DUNGEON) == nil) and not (find_path(aAGENT.POSITION, aAGENT.DUNGEON.EXIT_LOCATION, aAGENT.DUNGEON)== nil))

   aAGENT.hasKEY = false;
   aAGENT.seesKEY = false;
   aAGENT.seesEXIT = false;
   aAGENT.atEXIT = false;



   --initalize parameters
   aAGENT.DUNGEON.EXPLORED = {};
   aAGENT.DUNGEON.PELLETS = {};
   aAGENT.DUNGEON.crystals = 0;
   aAGENT.DUNGEON.total_squares = 0;

   --Initialize Exploration Variables
   for i=1,iDUNGEON_WIDTH do
	  aAGENT.DUNGEON.EXPLORED[i] = {};
	  aAGENT.DUNGEON.PELLETS[i] = {};
      for j=1,iDUNGEON_HEIGHT do
		 aAGENT.DUNGEON.EXPLORED[i][j] = false;
		 aAGENT.DUNGEON.PELLETS[i][j] = true;
		 if (count(aAGENT.DUNGEON[i][j], true) < 4) then aAGENT.DUNGEON.total_squares = aAGENT.DUNGEON.total_squares + 1; end
	  end


   end

   --Initialize the Agent Position
   aAGENT.POSITION = random_cell(random_cell_agent);

   --Initialize direction
   aAGENT.DIRECTION = direction_picker();

   --Darkway Algorithm Stuff for the Agent
   aAGENT.DUNGEON.DARKWAYS = {};

   --Initial Exploration around agent position
   agent_explore();

end

function load_new_dungeon()
   random_dungeon_params();

   -- -- -- -- -- -- -- -- -- -- -- --
   -- Build the new dungeons
   -- -- -- -- -- -- -- -- -- -- -- --
   build_human_dungeon();
   build_agent_dungeon();

end

function begin_new_game()

   if (selector3 == 1) then time_remaining = 60;
   elseif (selector3 == 2) then time_remaining = 180;
   elseif (selector3 == 3) then time_remaining = 300; end
   game_length = time_remaining;

   if (selector4 == 1) then fDAY_LENGTH = 0.125;
   elseif (selector4 == 2) then fDAY_LENGTH = 0.070;
   elseif (selector4 == 3) then fDAY_LENGTH = 0.02; end

   aHUMAN.score = 0;
   aAGENT.score = 0;
   aHUMAN.level = 1;
   aAGENT.level = 1;
   game_active = true;
   load_new_dungeon();

end

function wrap(selector, mini, maxi)
   love.audio.play(sfx1);
   if (selector > maxi) then return mini; elseif (selector < mini) then return maxi; else return selector; end
end

function love.keypressed(key, unicode)
   -- -- -- -- -- -- -- -- -- -- -- --
   -- Key presses
   -- -- -- -- -- -- -- -- -- -- -- --
   if (window == 1) then
      --menu selector
      if (key =='up') then
	     love.audio.play(sfx1);
	     selector1 = selector1+1;
		 if (selector1 > 2) then selector1 = 1; end
	  end

	  if (key =='down') then
	     love.audio.play(sfx1);
	     selector1 = selector1-1;
		 if (selector1 < 1) then selector1 = 2; end
	  end

      if (key == 'return' and selector1 == 1) then
         window = 2;
      end
   elseif (window == 2) then
      if (key == "up") then
	     selector2 = selector2 - 1;
		 if (selector2 < 1) then selector2 = 3; end
	  end

	  if (key == "down") then
	     selector2 = selector2 + 1;
		 if (selector2 > 3) then selector2 = 1; end
	  end

	  if (selector2 == 1) then
	     if (key == "right") then selector3 = wrap(selector3+1, 1, 3); end
		 if (key == "left") then selector3 = wrap(selector3-1, 1, 3); end
	  elseif (selector2 == 2) then
	     if (key == "right") then selector4 = wrap(selector4+1, 1, 3); end
		 if (key == "left") then selector4 = wrap(selector4-1, 1, 3); end
	  elseif (selector2 == 3) then
	     if (key == "right") then selector5 = wrap(selector5+1, 1, 2); end
		 if (key == "left") then selector5 = wrap(selector5-1, 1, 2); end

		 if (key == "return" and selector5 == 1) then window = 1;
		 elseif (key == "return" and selector5 == 2) then begin_new_game(); window = 4; end
	  end

   elseif (window == 4) then

	   if (key == 'N' or key == 'n' and game_active == false) then
	      --randomize
	      window = 1;
	   end

	   if (key == 'Q' or key == 'q') then os.exit(); end

	   if not (GAME_OVER) then
		   --[[if (key == 'left') then
		      move_in_direction(1);
		   end

		   if (key == 'down') then
		      move_in_direction(2);
		   end

		   if (key == 'right') then
		      move_in_direction(3);
		   end

		   if (key == 'up') then
		      move_in_direction(4);
		   end--]]

		   if (key == 'g' or key == 'G') then
		      bGOD_MODE = not(bGOD_MODE);
		   end
	   end

	   if (key == 'S' or key == 's') then statwindow = not(statwindow); end

	   keystrokes = keystrokes+1;
   end -- window controller
end

function on_exit()

end
