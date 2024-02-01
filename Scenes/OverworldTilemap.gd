extends TileMap

# add a function to debug mouse position on screen

@onready var tall_grass = preload("res://InteractiveTiles/tall_grass.tscn")
var interactive_tiles_layer = 2

func _ready():
	# Call function to find and replace grass tiles
	find_and_spawn_grass()

func find_and_spawn_grass():
	var tile_data = get_used_cells(interactive_tiles_layer)
	for i in range(0, tile_data.size()):
		var tile = get_cell_tile_data(interactive_tiles_layer, tile_data[i])
		print_debug(tile.get_custom_data("TallGrass"))
	
	# var test_data = tile_data.get_custom_data("TallGrass")
	# print("Test data: " + str(test_data))
