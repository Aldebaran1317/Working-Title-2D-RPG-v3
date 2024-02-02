extends TileMap

# add a function to debug mouse position on screen

@onready var tall_grass_scene = preload("res://InteractiveTiles/tall_grass.tscn")
var interactive_tiles_layer = 2

var border_layer = 0 # Set the layer where the borders should be drawn
var border_tile_size = 2
var border_tile_source = 2 # Set this to the ID of your border tile
var border_tile_coords = Vector2(0,0) # Set this to the atlas coords of your border tile

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
	var size = get_used_rect().size
	var start_point = get_used_rect().position
	print_debug("Drawing borders with size: ", size, " and start point: ", start_point)

	# Top and Bottom borders
	for depth in range(border_depth):
		for x in range(start_point.x - border_tile_size * border_depth, start_point.x + size.x + border_tile_size * border_depth):
			for offset_x in range(border_tile_size):
				set_cell(border_layer, Vector2i(x + offset_x, start_point.y - 1 - depth * border_tile_size), border_tile_source, border_tile_coords)
				set_cell(border_layer, Vector2i(x + offset_x, start_point.y + size.y + border_tile_size - 1 + depth * border_tile_size), border_tile_source, border_tile_coords)


	# Left and Right borders
	for depth in range(border_depth):
		for y in range(start_point.y - border_tile_size * border_depth, start_point.y + size.y + border_tile_size * border_depth):
			for offset_y in range(border_tile_size):
				set_cell(border_layer, Vector2i(start_point.x - border_tile_size - depth * border_tile_size, y + offset_y), border_tile_source, border_tile_coords)
				set_cell(border_layer, Vector2i(start_point.x + size.x + depth * border_tile_size, y + offset_y), border_tile_source, border_tile_coords)
