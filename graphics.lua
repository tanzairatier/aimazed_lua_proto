function love.draw()


   car_sprites = {};
   car_sprites[1] = love.graphics.newImage("sprites/car_left.png");
   car_sprites[2] = love.graphics.newImage("sprites/car_down.png");
   car_sprites[3] = love.graphics.newImage("sprites/car_right.png");
   car_sprites[4] = love.graphics.newImage("sprites/car_up.png");

   key_sprite = love.graphics.newImage("sprites/key.png");
   exit_sprite = love.graphics.newImage("sprites/exit.png");
   exit_locked_sprite = love.graphics.newImage("sprites/exit_locked.png");

   function draw_crystal(x, y, offset)
   local alpha = 0;
      if (crystalalpha > 255) then
	     alpha = 255 - (crystalalpha - 255);
	  else
	     alpha = crystalalpha;
	  end
      love.graphics.setColor(30, 60, 180, alpha);
      love.graphics.line(offset.x+(x-1)*iCELL_WIDTH+2, offset.y+(y-1)*iCELL_HEIGHT+iCELL_HEIGHT/2, offset.x+(x-1)*iCELL_WIDTH+iCELL_WIDTH-3, offset.y+(y-1)*iCELL_HEIGHT+iCELL_HEIGHT/2);
	  love.graphics.line(offset.x+(x-1)*iCELL_WIDTH+iCELL_WIDTH*0.3, offset.y+(y-1)*iCELL_HEIGHT+4, offset.x+(x-1)*iCELL_WIDTH+iCELL_WIDTH*0.6, offset.y+(y-1)*iCELL_HEIGHT+iCELL_HEIGHT-4);
	  love.graphics.line(offset.x+(x-1)*iCELL_WIDTH+iCELL_WIDTH*0.6, offset.y+(y-1)*iCELL_HEIGHT+4, offset.x+(x-1)*iCELL_WIDTH+iCELL_WIDTH*0.3, offset.y+(y-1)*iCELL_HEIGHT+iCELL_HEIGHT-4);

   end

   iCELL_WIDTH = 16;
   iCELL_HEIGHT = 16;

   iCELL_WIDTH_AGENT = 5;
   iCELL_WIDTH_AGENT = 5;



   colors = {};
   colors["stone"] = {150, 150, 150, 255};
   colors["grid-line"] = {190, 190, 190, 0};
   colors["wall"] = {200, 30, 30, 255};

   iCELL_OFFSET = {x = (love.graphics.getWidth()-iCELL_WIDTH*iDUNGEON_WIDTH)*0.105,
				   y = (love.graphics.getHeight()-iCELL_HEIGHT*iDUNGEON_HEIGHT)*0.60};


   iCELL_OFFSET_AGENT = {x = (love.graphics.getWidth()-iCELL_WIDTH*iDUNGEON_WIDTH)*0.885,
				   y = (love.graphics.getHeight()-iCELL_HEIGHT*iDUNGEON_HEIGHT)*0.60};

   local function draw_cell(x, y, color, offset)
      love.graphics.setColor(unpack(color));
	  love.graphics.rectangle('fill', offset.x+(x-1)*iCELL_WIDTH, offset.y+(y-1)*iCELL_HEIGHT, iCELL_WIDTH, iCELL_HEIGHT);
   end

   local function draw_cell_wall(x, y, wall, color, offset)
      love.graphics.setColor(unpack(color));
	  if (wall == 1) then
	     love.graphics.line(offset.x+(x-1)*iCELL_WIDTH, offset.y+(y-1)*iCELL_HEIGHT, offset.x+(x-1)*iCELL_WIDTH, offset.y+(y-1)*iCELL_HEIGHT+iCELL_HEIGHT);
	  elseif (wall == 2) then
	     love.graphics.line(offset.x+(x-1)*iCELL_WIDTH, offset.y+(y-1)*iCELL_HEIGHT+iCELL_HEIGHT, offset.x+(x-1)*iCELL_WIDTH+iCELL_WIDTH, offset.y+(y-1)*iCELL_HEIGHT+iCELL_HEIGHT);
	  elseif (wall == 3) then
	     love.graphics.line(offset.x+(x-1)*iCELL_WIDTH+iCELL_WIDTH, offset.y+(y-1)*iCELL_HEIGHT, offset.x+(x-1)*iCELL_WIDTH+iCELL_WIDTH, offset.y+(y-1)*iCELL_HEIGHT+iCELL_HEIGHT);
	  elseif (wall == 4) then
	     love.graphics.line(offset.x+(x-1)*iCELL_WIDTH, offset.y+(y-1)*iCELL_HEIGHT, offset.x+(x-1)*iCELL_WIDTH+iCELL_WIDTH, offset.y+(y-1)*iCELL_HEIGHT);
	  end
   end


   --love.graphics.setFont('font/fs_bas_relief_.ttf', 48)
   --love.graphics.setFont('font/continuum Medium.ttf', 24)
   love.graphics.setFont('font/BatmanForeverAlternate.ttf', 24)
   arrow_gfx = love.graphics.newImage("arrow_selector.png");
   arrow2_gfx = love.graphics.newImage("arrow_selector2.png");
   game_logo_gfx = love.graphics.newImage("game_logo.png");

   if (window == 1) then
      --Draw Title Logo
      local logo = {x=0.50, y = 0.15, h=254, w = 520};
      love.graphics.setColor(255, 255, 255, 255);
      love.graphics.draw(game_logo_gfx, (love.graphics.getWidth()-logo.w)*logo.x, (love.graphics.getHeight()-logo.h)*logo.y);

      --Draw Menu Items
      love.graphics.setColor(255, 255, 255, 255);
      love.graphics.printf("New Game", 0, love.graphics.getHeight()*0.86, love.graphics.getWidth(), 'center');
      love.graphics.printf("High Scores", 0, love.graphics.getHeight()*0.90, love.graphics.getWidth(), 'center');

      --Draw Menu Selector
      love.graphics.setColor(255, 255, 0, 255);
      love.graphics.setFont(14);
      local selector = {x = 0.35, y = 0.86, h = 11, w = 21};
      love.graphics.draw(arrow_gfx, (love.graphics.getWidth()-selector.w)*selector.x, (love.graphics.getHeight()-selector.h)*(selector.y+0.04*selector1) - 14);
      --love.graphics.setFont(11);

	  --draw car animation
	  love.graphics.draw(car_sprites[3], car_x, love.graphics.getHeight()*0.50);


   elseif (window == 2) then
	  --Draw Title Logo
      local logo = {x=0.50, y = 0.15, h=254, w = 520};
      love.graphics.setColor(255, 255, 255, 255);
      love.graphics.draw(game_logo_gfx, (love.graphics.getWidth()-logo.w)*logo.x, (love.graphics.getHeight()-logo.h)*logo.y);

      love.graphics.setColor(255, 255, 255, 255);
      love.graphics.print("1. Select a Time Limit", love.graphics.getWidth()*0.05, love.graphics.getHeight()*0.48);
	  love.graphics.printf("1:00", love.graphics.getWidth()*0.07, love.graphics.getHeight()*0.54, love.graphics.getWidth()*0.88, "left");
	  love.graphics.printf("3:00", love.graphics.getWidth()*0.05, love.graphics.getHeight()*0.54, love.graphics.getWidth()*0.90, "center");
	  love.graphics.printf("5:00", love.graphics.getWidth()*0.05, love.graphics.getHeight()*0.54, love.graphics.getWidth()*0.90, "right");
      if (selector2 == 1) then
	     love.graphics.setLineWidth(2);
		  love.graphics.setColor(255, 255, 0, 255);
	  else
	     love.graphics.setLineWidth(1);
	  end
  	  love.graphics.rectangle('line', love.graphics.getWidth()*0.05, love.graphics.getHeight()*0.51, love.graphics.getWidth()*0.90, love.graphics.getHeight()*0.10);
	  if (selector3 == 1) then
	     love.graphics.draw(arrow2_gfx, love.graphics.getWidth()*0.09, love.graphics.getHeight()*0.57);
	  elseif (selector3 == 2) then
	     love.graphics.draw(arrow2_gfx, love.graphics.getWidth()*0.49, love.graphics.getHeight()*0.57);
	  elseif (selector3 == 3) then
	     love.graphics.draw(arrow2_gfx, love.graphics.getWidth()*0.905, love.graphics.getHeight()*0.57);
	  end

      love.graphics.setColor(255, 255, 255, 255);
      love.graphics.print("2. Set Computer Difficulty", love.graphics.getWidth()*0.05, love.graphics.getHeight()*0.65);
	  love.graphics.printf("Easy",   love.graphics.getWidth()*0.07, love.graphics.getHeight()*0.71, love.graphics.getWidth()*0.88, "left");
	  love.graphics.printf("Medium", love.graphics.getWidth()*0.05, love.graphics.getHeight()*0.71, love.graphics.getWidth()*0.90, "center");
	  love.graphics.printf("Hard",   love.graphics.getWidth()*0.05, love.graphics.getHeight()*0.71, love.graphics.getWidth()*0.90, "right");
      love.graphics.setLineWidth(2);
      if (selector2 == 2) then
	     love.graphics.setLineWidth(2);
		 love.graphics.setColor(255, 255, 0, 255);
	  else
	     love.graphics.setLineWidth(1);
		 love.graphics.setColor(255, 255, 255, 255);
	  end
	  love.graphics.rectangle('line', love.graphics.getWidth()*0.05, love.graphics.getHeight()*0.68, love.graphics.getWidth()*0.90, love.graphics.getHeight()*0.10);
	  if (selector4 == 1) then
	     love.graphics.draw(arrow2_gfx, love.graphics.getWidth()*0.10, love.graphics.getHeight()*0.74);
	  elseif (selector4 == 2) then
	     love.graphics.draw(arrow2_gfx, love.graphics.getWidth()*0.49, love.graphics.getHeight()*0.74);
	  elseif (selector4 == 3) then
	     love.graphics.draw(arrow2_gfx, love.graphics.getWidth()*0.89, love.graphics.getHeight()*0.74);
	  end

      love.graphics.setColor(255, 255, 255, 255);
      love.graphics.print("3. Confirm", love.graphics.getWidth()*0.05, love.graphics.getHeight()*0.82);
	  love.graphics.printf("Cancel",        love.graphics.getWidth()*0.25, love.graphics.getHeight()*0.88, love.graphics.getWidth()*0.70, "left");
	  love.graphics.printf("Begin Game!",   love.graphics.getWidth()*0.25, love.graphics.getHeight()*0.88, love.graphics.getWidth()*0.55, "right");
      love.graphics.setLineWidth(2);
	  love.graphics.setColor(255, 255, 0, 255);
      if (selector2 == 3) then
	     love.graphics.setLineWidth(2);
		 love.graphics.setColor(255, 255, 0, 255);
	  else
	     love.graphics.setLineWidth(1);
		 love.graphics.setColor(255, 255, 255, 255);
	  end
	  love.graphics.rectangle('line', love.graphics.getWidth()*0.05, love.graphics.getHeight()*0.85, love.graphics.getWidth()*0.90, love.graphics.getHeight()*0.10);
	  if (selector5 == 1) then
	     love.graphics.draw(arrow2_gfx, love.graphics.getWidth()*0.2975, love.graphics.getHeight()*0.91);
	  elseif (selector5 == 2) then
	     love.graphics.draw(arrow2_gfx, love.graphics.getWidth()*0.6925, love.graphics.getHeight()*0.91);
	  end

   elseif (window == 4) then


   --draw map
   for i=1,iDUNGEON_WIDTH do
      for j=1,iDUNGEON_HEIGHT do


         if not (statwindow) then
			 if (aAGENT.DUNGEON.EXPLORED[i][j] == false) and not (bGOD_MODE) then
				draw_cell(i, j, {200, 200, 200, 80}, iCELL_OFFSET_AGENT);
			 elseif (count(aAGENT.DUNGEON[i][j], true) == 4) then
				draw_cell(i, j, colors["stone"], iCELL_OFFSET_AGENT);
			 else
				for k=1,4 do
				   if (aAGENT.DUNGEON[i][j][k] == true) then
					  draw_cell_wall(i, j, k, {0, 0, 255, 255}, iCELL_OFFSET_AGENT);
				   end
				end
			 end
         end

		 if (aHUMAN.DUNGEON.EXPLORED[i][j] == false) and not (bGOD_MODE) then
		    draw_cell(i, j, {200, 200, 200, 80}, iCELL_OFFSET);
		 elseif (count(aHUMAN.DUNGEON[i][j], true) == 4) then
		    draw_cell(i, j, colors["stone"], iCELL_OFFSET);
		 else
		    for k=1,4 do
		       if (aHUMAN.DUNGEON[i][j][k] == true) then
			      draw_cell_wall(i, j, k, colors["wall"], iCELL_OFFSET);
			   end
		    end
		 end

		 --draw pellets
	 if not (statwindow) then
		 love.graphics.setColor(255, 80, 0, 255);
		 if (aAGENT.DUNGEON.PELLETS[i][j] == true and aAGENT.DUNGEON.EXPLORED[i][j]) then
		    --love.graphics.rectangle('fill', iCELL_OFFSET_AGENT.x + iCELL_WIDTH*(i-1)+4, iCELL_OFFSET_AGENT.y+iCELL_HEIGHT*(j-1)+4, 5, 5);
			draw_crystal(i, j, iCELL_OFFSET_AGENT);
		 end
	 end
		 if (aHUMAN.DUNGEON.PELLETS[i][j] == true and aHUMAN.DUNGEON.EXPLORED[i][j]) then
		    --love.graphics.rectangle('fill', iCELL_OFFSET.x + iCELL_WIDTH*(i-1)+4, iCELL_OFFSET.y+iCELL_HEIGHT*(j-1)+4, 5, 5);
			draw_crystal(i, j, iCELL_OFFSET);
		 end
      end
   end


   --draw crystal guage for human
   love.graphics.setColor(255, 255, 0, 180);
   local alpha = 0;
   if (crystalalpha > 255) then
	  alpha = 255 - (crystalalpha - 255);
   else
	  alpha = crystalalpha;
   end


   if ((aHUMAN.DUNGEON.crystals/aHUMAN.DUNGEON.total_squares) > 0.70) then
      love.graphics.setColor(0, 255, 255, alpha);
   else
      love.graphics.setColor(0, 255, 255, 255);
   end
   love.graphics.rectangle('fill', iCELL_OFFSET.x - iCELL_WIDTH - 5, (iCELL_OFFSET.y + iCELL_HEIGHT*iDUNGEON_HEIGHT) - ((aHUMAN.DUNGEON.crystals/aHUMAN.DUNGEON.total_squares)*(iCELL_HEIGHT*iDUNGEON_HEIGHT)), iCELL_WIDTH-2, (aHUMAN.DUNGEON.crystals/aHUMAN.DUNGEON.total_squares)*(iCELL_HEIGHT*iDUNGEON_HEIGHT));
   love.graphics.setColor(255, 0, 0, 255);
   love.graphics.rectangle('line', iCELL_OFFSET.x - iCELL_WIDTH - 5, iCELL_OFFSET.y, iCELL_WIDTH, iCELL_HEIGHT*iDUNGEON_HEIGHT);
   love.graphics.line(iCELL_OFFSET.x - iCELL_WIDTH - 5, (iCELL_OFFSET.y + iCELL_HEIGHT*iDUNGEON_HEIGHT) - (0.70*(iCELL_HEIGHT*iDUNGEON_HEIGHT)), iCELL_OFFSET.x - iCELL_WIDTH - 5 + iCELL_WIDTH, (iCELL_OFFSET.y + iCELL_HEIGHT*iDUNGEON_HEIGHT) - (0.70*(iCELL_HEIGHT*iDUNGEON_HEIGHT)));

   --draw crystal guage for agent
   if ((aAGENT.DUNGEON.crystals/aAGENT.DUNGEON.total_squares) > 0.70) then
      love.graphics.setColor(0, 255, 255, alpha);
   else
      love.graphics.setColor(0, 255, 255, 255);
   end
   love.graphics.rectangle('fill', iCELL_OFFSET_AGENT.x - iCELL_WIDTH - 5, (iCELL_OFFSET_AGENT.y + iCELL_HEIGHT*iDUNGEON_HEIGHT) - ((aAGENT.DUNGEON.crystals/aAGENT.DUNGEON.total_squares)*(iCELL_HEIGHT*iDUNGEON_HEIGHT)), iCELL_WIDTH-2, (aAGENT.DUNGEON.crystals/aAGENT.DUNGEON.total_squares)*(iCELL_HEIGHT*iDUNGEON_HEIGHT));
   love.graphics.setColor(0, 0, 255, 255);
   love.graphics.rectangle('line', iCELL_OFFSET_AGENT.x - iCELL_WIDTH - 5, iCELL_OFFSET_AGENT.y, iCELL_WIDTH, iCELL_HEIGHT*iDUNGEON_HEIGHT)
   love.graphics.line(iCELL_OFFSET_AGENT.x - iCELL_WIDTH - 5, (iCELL_OFFSET_AGENT.y + iCELL_HEIGHT*iDUNGEON_HEIGHT) - (0.70*(iCELL_HEIGHT*iDUNGEON_HEIGHT)), iCELL_OFFSET_AGENT.x - iCELL_WIDTH - 5 + iCELL_WIDTH, (iCELL_OFFSET_AGENT.y + iCELL_HEIGHT*iDUNGEON_HEIGHT) - (0.70*(iCELL_HEIGHT*iDUNGEON_HEIGHT)));

   if (game_active) then
	   --draw agent Car
	   if not (statwindow) then
		love.graphics.setColor(200, 255, 200, 255);
		love.graphics.draw(car_sprites[aAGENT.face], iCELL_OFFSET_AGENT.x+(aAGENT.POSITION.x-1)*iCELL_WIDTH, iCELL_OFFSET_AGENT.y+(aAGENT.POSITION.y-1)*iCELL_HEIGHT);
		--love.graphics.rectangle('fill', iCELL_OFFSET_AGENT.x+(aAGENT.POSITION.x-1)*iCELL_WIDTH+2, iCELL_OFFSET_AGENT.y+(aAGENT.POSITION.y-1)*iCELL_HEIGHT+2, iCELL_WIDTH-4, iCELL_HEIGHT-4);
	   end

	   --draw Human Car
	   love.graphics.setColor(255, 255, 255, 255);
	   love.graphics.draw(car_sprites[aHUMAN.face], iCELL_OFFSET.x+(aHUMAN.POSITION.x-1)*iCELL_WIDTH, iCELL_OFFSET.y+(aHUMAN.POSITION.y-1)*iCELL_HEIGHT);
	   --love.graphics.rectangle('fill', iCELL_OFFSET.x+(aHUMAN.POSITION.x-1)*iCELL_WIDTH+2, iCELL_OFFSET.y+(aHUMAN.POSITION.y-1)*iCELL_HEIGHT+2, iCELL_WIDTH-4, iCELL_HEIGHT-4);

	   --draw darkways
	   love.graphics.setColor(255, 255, 255, 255);
	   for i,v in ipairs(aAGENT.DUNGEON.DARKWAYS) do
		  --love.graphics.rectangle('fill', iCELL_OFFSET_AGENT.x+(v.x-1)*iCELL_WIDTH+4, iCELL_OFFSET_AGENT.y+(v.y-1)*iCELL_HEIGHT+4, iCELL_WIDTH-8, iCELL_HEIGHT-8);
	   end

	   --Draw Agent Key
	   if (aAGENT.seesKEY or (bGOD_MODE)) then
		  --draw key
		  love.graphics.setColor(255, 255, 255, 255);
		  love.graphics.draw(key_sprite, iCELL_OFFSET_AGENT.x+(aAGENT.DUNGEON.KEY_LOCATION.x-1)*iCELL_WIDTH, iCELL_OFFSET_AGENT.y+(aAGENT.DUNGEON.KEY_LOCATION.y-1)*iCELL_HEIGHT);
		  --love.graphics.rectangle('fill', iCELL_OFFSET_AGENT.x+(aAGENT.DUNGEON.KEY_LOCATION.x-1)*iCELL_WIDTH+2, iCELL_OFFSET_AGENT.y+(aAGENT.DUNGEON.KEY_LOCATION.y-1)*iCELL_HEIGHT+2, iCELL_WIDTH-4, iCELL_HEIGHT-4);
	   end

	   --Draw Agent Exit
	   if (aAGENT.seesEXIT or (bGOD_MODE)) then
		  --draw exit
		  love.graphics.setColor(255, 255, 255, 255);
		  if (aAGENT.hasKEY and ((aAGENT.DUNGEON.crystals/aAGENT.DUNGEON.total_squares) > 0.70)) then
			 love.graphics.draw(exit_sprite,        iCELL_OFFSET_AGENT.x+(aAGENT.DUNGEON.EXIT_LOCATION.x-1)*iCELL_WIDTH, iCELL_OFFSET_AGENT.y+(aAGENT.DUNGEON.EXIT_LOCATION.y-1)*iCELL_HEIGHT);
		  else
			 love.graphics.draw(exit_locked_sprite, iCELL_OFFSET_AGENT.x+(aAGENT.DUNGEON.EXIT_LOCATION.x-1)*iCELL_WIDTH, iCELL_OFFSET_AGENT.y+(aAGENT.DUNGEON.EXIT_LOCATION.y-1)*iCELL_HEIGHT);
		  end
		  --love.graphics.rectangle('fill', iCELL_OFFSET_AGENT.x+(aAGENT.DUNGEON.EXIT_LOCATION.x-1)*iCELL_WIDTH+2, iCELL_OFFSET_AGENT.y+(aAGENT.DUNGEON.EXIT_LOCATION.y-1)*iCELL_HEIGHT+2, iCELL_WIDTH-4, iCELL_HEIGHT-4);
	   end

	   --Draw Human Key
	   if (aHUMAN.seesKEY or (bGOD_MODE)) then
		  --draw key
		  love.graphics.setColor(255, 255, 255, 255);
		  love.graphics.draw(key_sprite, iCELL_OFFSET.x+(aHUMAN.DUNGEON.KEY_LOCATION.x-1)*iCELL_WIDTH, iCELL_OFFSET.y+(aHUMAN.DUNGEON.KEY_LOCATION.y-1)*iCELL_HEIGHT);
		  --love.graphics.rectangle('fill', iCELL_OFFSET.x+(aHUMAN.DUNGEON.KEY_LOCATION.x-1)*iCELL_WIDTH+2, iCELL_OFFSET.y+(aHUMAN.DUNGEON.KEY_LOCATION.y-1)*iCELL_HEIGHT+2, iCELL_WIDTH-4, iCELL_HEIGHT-4);
	   end

	   --Draw Human Exit
	   if (aHUMAN.seesEXIT or (bGOD_MODE)) then
		  --draw exit
		  love.graphics.setColor(255, 255, 255, 255);
		  if (aHUMAN.hasKEY and (aHUMAN.DUNGEON.crystals/aHUMAN.DUNGEON.total_squares) > 0.70) then
			 love.graphics.draw(exit_sprite, iCELL_OFFSET.x+(aHUMAN.DUNGEON.EXIT_LOCATION.x-1)*iCELL_WIDTH, iCELL_OFFSET.y+(aHUMAN.DUNGEON.EXIT_LOCATION.y-1)*iCELL_HEIGHT);
		  else
			 love.graphics.draw(exit_locked_sprite, iCELL_OFFSET.x+(aHUMAN.DUNGEON.EXIT_LOCATION.x-1)*iCELL_WIDTH, iCELL_OFFSET.y+(aHUMAN.DUNGEON.EXIT_LOCATION.y-1)*iCELL_HEIGHT);
		  end
		  --love.graphics.rectangle('fill', iCELL_OFFSET.x+(aHUMAN.DUNGEON.EXIT_LOCATION.x-1)*iCELL_WIDTH+2, iCELL_OFFSET.y+(aHUMAN.DUNGEON.EXIT_LOCATION.y-1)*iCELL_HEIGHT+2, iCELL_WIDTH-4, iCELL_HEIGHT-4);
	   end
   else
      --draw end-game results
	  love.graphics.setColor(255, 255, 255, 255);
	  if (aHUMAN.score > aAGENT.score) then
	     love.graphics.printf("You Win!", iCELL_OFFSET.x, iCELL_OFFSET.y+(iCELL_HEIGHT*iDUNGEON_HEIGHT)*0.4, iCELL_WIDTH*iDUNGEON_WIDTH, "center");
		 love.graphics.printf("Agent Loses!", iCELL_OFFSET_AGENT.x, iCELL_OFFSET_AGENT.y+(iCELL_HEIGHT*iDUNGEON_HEIGHT)*0.4, iCELL_WIDTH*iDUNGEON_WIDTH, "center");
	  else
	     love.graphics.printf("You Lose!", iCELL_OFFSET.x, iCELL_OFFSET.y+(iCELL_HEIGHT*iDUNGEON_HEIGHT)*0.4, iCELL_WIDTH*iDUNGEON_WIDTH, "center");
		 love.graphics.printf("Agent Wins!", iCELL_OFFSET_AGENT.x, iCELL_OFFSET_AGENT.y+(iCELL_HEIGHT*iDUNGEON_HEIGHT)*0.4, iCELL_WIDTH*iDUNGEON_WIDTH, "center");
	  end

	  love.graphics.printf("Press (N) to Continue", iCELL_OFFSET.x, iCELL_OFFSET.y+(iCELL_HEIGHT*iDUNGEON_HEIGHT)*0.8, iCELL_WIDTH*iDUNGEON_WIDTH, "center");
   end

   --Draw Map Box
   love.graphics.setColor(255, 0, 0, 255);
   love.graphics.setLineWidth(2);
   love.graphics.rectangle('line', iCELL_OFFSET.x, iCELL_OFFSET.y, iCELL_WIDTH*iDUNGEON_WIDTH, iCELL_HEIGHT*iDUNGEON_HEIGHT);
   love.graphics.setLineWidth(1);

   love.graphics.setColor(0, 0, 255, 255);
   love.graphics.setLineWidth(2);
   love.graphics.rectangle('line', iCELL_OFFSET_AGENT.x, iCELL_OFFSET_AGENT.y, iCELL_WIDTH*iDUNGEON_WIDTH, iCELL_HEIGHT*iDUNGEON_HEIGHT);
   love.graphics.setLineWidth(1);

   --Game Info
   love.graphics.setColor(255, 255, 255, 255);

   --draw player scorebox
   local player_scorebox_frame = {x=iCELL_OFFSET.x, y=iCELL_OFFSET.y - 45, h=40, w=iCELL_WIDTH*iDUNGEON_WIDTH};
   love.graphics.setColor(200, 200, 200, 80);
   love.graphics.rectangle('fill', player_scorebox_frame.x, player_scorebox_frame.y, player_scorebox_frame.w, player_scorebox_frame.h);
   love.graphics.setColor(255, 0, 0, 255);
   love.graphics.setLineWidth(2);
   love.graphics.rectangle('line', player_scorebox_frame.x, player_scorebox_frame.y, player_scorebox_frame.w, player_scorebox_frame.h);
   love.graphics.setLineWidth(1);

   --draw computer scoreboxs
   local agent_scorebox_frame = {x=iCELL_OFFSET_AGENT.x, y=iCELL_OFFSET_AGENT.y - 45, h=40, w=iCELL_WIDTH*iDUNGEON_WIDTH};
   love.graphics.setColor(200, 200, 200, 80);
   love.graphics.rectangle('fill', agent_scorebox_frame.x, agent_scorebox_frame.y, agent_scorebox_frame.w, agent_scorebox_frame.h);
   love.graphics.setColor(0, 0, 255, 255);
   love.graphics.setLineWidth(2);
   love.graphics.rectangle('line', agent_scorebox_frame.x, agent_scorebox_frame.y, agent_scorebox_frame.w, agent_scorebox_frame.h);
   love.graphics.setLineWidth(1);

   --draw player score
   love.graphics.setColor(255, 255, 255, 255);
   love.graphics.print("Score: " .. aHUMAN.score, player_scorebox_frame.x + player_scorebox_frame.w*0.03, player_scorebox_frame.y+player_scorebox_frame.h*0.40);
   love.graphics.print("Level: " .. aHUMAN.level, player_scorebox_frame.x + player_scorebox_frame.w*0.63, player_scorebox_frame.y+player_scorebox_frame.h*0.40);

   --draw computer score
   love.graphics.setColor(255, 255, 255, 255);
   love.graphics.print("Score: " .. aAGENT.score, agent_scorebox_frame.x + agent_scorebox_frame.w*0.03, agent_scorebox_frame.y+agent_scorebox_frame.h*0.40);
   love.graphics.print("Level: " .. aAGENT.level, agent_scorebox_frame.x + agent_scorebox_frame.w*0.63, agent_scorebox_frame.y+agent_scorebox_frame.h*0.40);




   --Text stuff at bottom about Key and Exit
   if (aHUMAN.hasKEY) then
      love.graphics.setColor(255, 255, 0, 255);
   else
      love.graphics.setColor(15, 15, 15, 255);
   end
   love.graphics.printf("You have the Key!", iCELL_OFFSET.x, iCELL_OFFSET.y+iCELL_HEIGHT*iDUNGEON_HEIGHT + love.graphics.getHeight()*0.015, iCELL_WIDTH*iDUNGEON_WIDTH, 'center');

   if (aHUMAN.seesEXIT) then
      love.graphics.setColor(0, 0, 255, 255);
   else
      love.graphics.setColor(15, 15, 15, 255);
   end
   love.graphics.printf("You see the Exit!", iCELL_OFFSET.x, iCELL_OFFSET.y+iCELL_HEIGHT*iDUNGEON_HEIGHT + love.graphics.getHeight()*0.04, iCELL_WIDTH*iDUNGEON_WIDTH, 'center');

   if ((aHUMAN.DUNGEON.crystals/aHUMAN.DUNGEON.total_squares) > 0.70) then
      love.graphics.setColor(0, 255, 255, 255);
   else
      love.graphics.setColor(15, 15, 15, 255);
   end
   love.graphics.printf("Crystal Drive Ready!", iCELL_OFFSET.x, iCELL_OFFSET.y+iCELL_HEIGHT*iDUNGEON_HEIGHT + love.graphics.getHeight()*0.065, iCELL_WIDTH*iDUNGEON_WIDTH, 'center');

   if (aAGENT.hasKEY) then
      love.graphics.setColor(255, 255, 0, 255);
   else
      love.graphics.setColor(15, 15, 15, 255);
   end
   love.graphics.printf("Agent Key Found!", iCELL_OFFSET_AGENT.x, iCELL_OFFSET.y+iCELL_HEIGHT*iDUNGEON_HEIGHT + love.graphics.getHeight()*0.015, iCELL_WIDTH*iDUNGEON_WIDTH, 'center');

   if (aAGENT.seesEXIT) then
      love.graphics.setColor(0, 0, 255, 255);
   else
      love.graphics.setColor(15, 15, 15, 255);
   end
   love.graphics.printf("Agent Exit Found!", iCELL_OFFSET_AGENT.x, iCELL_OFFSET.y+iCELL_HEIGHT*iDUNGEON_HEIGHT + love.graphics.getHeight()*0.04, iCELL_WIDTH*iDUNGEON_WIDTH, 'center');

   if ((aAGENT.DUNGEON.crystals/aAGENT.DUNGEON.total_squares) > 0.70) then
      love.graphics.setColor(0, 255, 255, 255);
   else
      love.graphics.setColor(15, 15, 15, 255);
   end
   love.graphics.printf("Crystal Drive Ready!", iCELL_OFFSET_AGENT.x, iCELL_OFFSET.y+iCELL_HEIGHT*iDUNGEON_HEIGHT + love.graphics.getHeight()*0.065, iCELL_WIDTH*iDUNGEON_WIDTH, 'center');

   --draw timer at top
   love.graphics.setColor(255, 255, 255, 255);
   if (game_active) then
      love.graphics.printf("Time Remaining", 0, 20, love.graphics.getWidth(), 'center');
      love.graphics.printf(math.floor(time_remaining/60)..":"..string.format("%02.0f", math.floor(time_remaining - 60*(math.floor(time_remaining/60)))), 0, 40, love.graphics.getWidth(), 'center');
   else
      love.graphics.printf("Times Up!", 0, 20, love.graphics.getWidth(), 'center');
   end


   --if statwindow showing, then overwrite the agent screen
   if (statwindow) then
	   love.graphics.setColor(200, 200, 200, 80);
	   love.graphics.rectangle('fill', iCELL_OFFSET_AGENT.x, iCELL_OFFSET_AGENT.y, iDUNGEON_WIDTH*iCELL_WIDTH, iDUNGEON_HEIGHT*iCELL_HEIGHT);
	   love.graphics.setLineWidth(2);
	   love.graphics.setColor(0, 0, 255, 255);
	   love.graphics.rectangle('line', iCELL_OFFSET_AGENT.x, iCELL_OFFSET_AGENT.y, iDUNGEON_WIDTH*iCELL_WIDTH, iDUNGEON_HEIGHT*iCELL_HEIGHT);
	   love.graphics.setLineWidth(1);

	   love.graphics.setColor(255, 255, 255, 255);
	   love.graphics.print("Keystrokes..."..keystrokes, iCELL_OFFSET_AGENT.x+5, iCELL_OFFSET_AGENT.y + 25);
	   love.graphics.print("Moves Made..."..movesmade, iCELL_OFFSET_AGENT.x+5, iCELL_OFFSET_AGENT.y + 50);
	   love.graphics.print("Play Time..."..math.floor(math.floor(total_time_played)/60)..":"..math.ceil(total_time_played) - 60*math.floor(math.ceil(total_time_played)/60), iCELL_OFFSET_AGENT.x+5, iCELL_OFFSET_AGENT.y + 75);
   end

   --draw over top the map windows if game is over


   end -- end window controller

end
