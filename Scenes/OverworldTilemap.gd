extends TileMap

# add a function to debug mouse position on screen

@onready var tall_grass_scene = preload("res://InteractiveTiles/tall_grass.tscn")
var interactive_tiles_layer = 2

func _ready():
	draw_borders()
	find_and_spawn_interactive_tiles()

func find_and_spawn_interactive_tiles():
	var tile_data = get_used_cells(interactive_tiles_layer)
	for i in range(0, tile_data.size()):
		var tile := get_cell_tile_data(interactive_tiles_layer, tile_data[i])
		if tile.get_custom_data("TileType") == "tall_grass":
			set_cell(interactive_tiles_layer,tile_data[i],-1)
			var tall_grass = tall_grass_scene.instantiate()
			var pos = map_to_local(tile_data[i])
			tall_grass.position = Vector2(pos.x-8, pos.y+8)
			add_child(tall_grass)
		else: # if no matching rule
			continue

func draw_borders(border_depth=4):
	var border_layer = 3
	var border_tile_source = 1
	var border_tile_coords = Vector2(4,0)
	var ground_layer = 0
	var ground_tile_source = 1
	var ground_tile_coords = Vector2(3,0)
	
	var size = get_used_rect().size
	var start_point = get_used_rect().position
	var repeat_x = size.x + 4
	var repeat_y = size.y + 4
	
	print_debug("Drawing borders with size: ", size, " and start point: ", start_point)
	
	# draw top row
	for depth in range(0, border_depth):
		for x in range(0-(2*depth), repeat_x+(2*depth), 2):
			set_cell( # bg bottom left
				ground_layer,
				Vector2i(((start_point.x - 2)+(x)), start_point.y - 1 - (2*depth)),
				ground_tile_source,
				ground_tile_coords
			)
			set_cell( # bg bottom right
				ground_layer,
				Vector2i(((start_point.x - 2)+(x))+1, start_point.y - 1 - (2*depth)),
				ground_tile_source,
				ground_tile_coords
			)
			set_cell( # bg top left
				ground_layer,
				Vector2i(((start_point.x - 2)+(x)), start_point.y - 2 - (2*depth)),
				ground_tile_source,
				ground_tile_coords
			)
			set_cell( # bg tpp right
				ground_layer,
				Vector2i(((start_point.x - 2)+(x))+1, start_point.y - 2 - (2*depth)),
				ground_tile_source,
				ground_tile_coords
			)
			set_cell( # border tile
				border_layer,
				Vector2i(((start_point.x - 2)+(x)), start_point.y - 1 - (2*depth)),
				border_tile_source,
				border_tile_coords
			)

	# draw right row
	for depth in range(0, border_depth):
		for y in range(0-(2*depth), repeat_y+(2*depth), 2):
			set_cell( # ground tile
				ground_layer,
				Vector2i(size.x + (2*depth), start_point.y +1+y),
				ground_tile_source,
				ground_tile_coords
			)
			set_cell( # ground tile
				ground_layer,
				Vector2i(size.x + (2*depth)+1, start_point.y +1+y),
				ground_tile_source,
				ground_tile_coords
			)
			set_cell( # ground tile
				ground_layer,
				Vector2i(size.x + (2*depth), start_point.y +1+y-1),
				ground_tile_source,
				ground_tile_coords
			)
			set_cell( # ground tile
				ground_layer,
				Vector2i(size.x + (2*depth)+1, start_point.y +1+y-1),
				ground_tile_source,
				ground_tile_coords
			)
			set_cell( # border tile
				border_layer,
				Vector2i(size.x + (2*depth), start_point.y +1+y),
				border_tile_source,
				border_tile_coords
			)
			
	# draw bottom row
	for depth in range(0, border_depth):
		for x in range(0-(2*depth), repeat_x+(2*depth), 2):
			set_cell( # ground tile
				ground_layer,
				Vector2i(((start_point.x - 2)+(x)), size.y + 1 + (2*depth)),
				ground_tile_source,
				ground_tile_coords
			)
			set_cell( # ground tile
				ground_layer,
				Vector2i(((start_point.x - 2)+(x))+1, size.y + 1 + (2*depth)),
				ground_tile_source,
				ground_tile_coords
			)
			set_cell( # ground tile
				ground_layer,
				Vector2i(((start_point.x - 2)+(x)), size.y + 1 + (2*depth)-1),
				ground_tile_source,
				ground_tile_coords
			)
			set_cell( # ground tile
				ground_layer,
				Vector2i(((start_point.x - 2)+(x))+1, size.y + 1 + (2*depth)-1),
				ground_tile_source,
				ground_tile_coords
			)
			set_cell( # border tile
				border_layer,
				Vector2i(((start_point.x - 2)+(x)), size.y + 1 + (2*depth)),
				border_tile_source,
				border_tile_coords
			)
			
	# draw left row
	for depth in range(0, border_depth):
		for y in range(0-(2*depth), repeat_y+(2*depth), 2):
			set_cell( # ground tile
				ground_layer,
				Vector2i(start_point.x - 2 - (2*depth), start_point.y +1+y),
				ground_tile_source,
				ground_tile_coords
			)
			set_cell( # ground tile
				ground_layer,
				Vector2i(start_point.x - 2 - (2*depth)+1, start_point.y +1+y),
				ground_tile_source,
				ground_tile_coords
			)
			set_cell( # ground tile
				ground_layer,
				Vector2i(start_point.x - 2 - (2*depth), start_point.y +1+y-1),
				ground_tile_source,
				ground_tile_coords
			)
			set_cell( # ground tile
				ground_layer,
				Vector2i(start_point.x - 2 - (2*depth)+1, start_point.y +1+y-1),
				ground_tile_source,
				ground_tile_coords
			)
			set_cell( # border tile
				border_layer,
				Vector2i(start_point.x - 2 - (2*depth), start_point.y +1+y),
				border_tile_source,
				border_tile_coords
			)
