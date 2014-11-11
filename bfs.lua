function bfs(start, goal, dungeon)
   aOPEN_LIST = {};
   aCLOSED_LIST = {};

   local function build_node(n, dist, par, len)
      return {node = n; distance = dist, parent = par, path_length = len};
   end

   local function find_best_node_index()
      --find best node (smallest distance)
	  local min_score = 999999999;
      for i,v in ipairs(aOPEN_LIST) do
	     if (v.distance < min_score) then min_score = v.distance; min_index = i; end
	  end
	  return min_index
   end

   local function match(n, position)
      return (n.node.x == position.x and n.node.y == position.y);
   end

   local function node_count(list, node)
      local cnt = 0;
	  for i,v in ipairs(list) do
	     if (match(v, node.node)) then cnt = cnt + 1; end
	  end
	  return cnt;
   end

   local function find_index(list, node)
      for i,v in ipairs(list) do
	     if (match(v, node.node)) then return i; end
	  end
   end

   local function distance(A, B)
      --Utility Function calculates euclidean distance between two objects
      return math.sqrt((A.x - B.x)^2 + (A.y - B.y)^2);
   end

   local function get_path_result(g, start)
      local result = {};
	  table.insert(result, g);

	  local nxt = g;

	  while not (nxt == nil) do
	     table.insert(result, nxt);
		 nxt = nxt.parent;
	  end

	  return result;
   end

   -- -- -- -- -- -- -- -- -- --
   -- 1: Evaluate and add start to Open List
   -- -- -- -- -- -- -- -- -- --
   local node = build_node(start, distance(start, goal), nil, 0);
   table.insert(aOPEN_LIST, node);

   -- -- -- -- -- -- -- -- -- --
   -- 2: Evaluate items in Open List
   -- -- -- -- -- -- -- -- -- --
   while (#aOPEN_LIST > 0) do
      --pick best node in open list
	  local best_node_index = find_best_node_index();
	  local best_node = aOPEN_LIST[best_node_index];

	  --move best node to closed list
	  table.remove(aOPEN_LIST, best_node_index);
	  table.insert(aCLOSED_LIST, best_node);

	  --goal test
	  if (match(best_node, goal)) then
	     --goal found; return a path result
		 return get_path_result(best_node, start);

	  else
	     --examine neighbors of best node
		 for i=1,4 do
		    if (dungeon[best_node.node.x][best_node.node.y][i] == false) then
			   local neighbor_node = build_node(cell_in_direction(best_node.node, i), distance(best_node.node, goal), best_node, best_node.path_length+1);
			  if (dungeon.EXPLORED[neighbor_node.node.x][neighbor_node.node.y] == true) then
			   local open_count = node_count(aOPEN_LIST, neighbor_node)
			   local closed_count = node_count(aCLOSED_LIST, neighbor_node)
			   if (open_count == 0 and closed_count == 0) then
			      --add neighbor to open list
				  table.insert(aOPEN_LIST, neighbor_node);
			   else
			      --check for better path and replace
				  if (open_count > 0) then
				     local open_index = find_index(aOPEN_LIST, neighbor_node);
				     if (aOPEN_LIST[open_index].path_length > neighbor_node.path_length) then
					    aOPEN_LIST[open_index].path_length = neighbor_node.path_length;
						aOPEN_LIST[open_index].parent = neighbor_node;
					 end
				  elseif (closed_count > 0) then
				     local closed_index = find_index(aCLOSED_LIST, neighbor_node);
				     if (aCLOSED_LIST[closed_index].path_length > neighbor_node.path_length) then
					    aCLOSED_LIST[closed_index].path_length = neighbor_node.path_length;
						aCLOSED_LIST[closed_index].parent = neighbor_node;
					 end
				  end
			   end
			  end
			end
		 end
	  end --end goal test



   end --end while

   -- -- -- -- -- -- -- -- -- --
   -- 3: No path found if you got here
   -- -- -- -- -- -- -- -- -- --
   return nil;




end
