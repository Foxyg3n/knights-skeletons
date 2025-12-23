class_name GridSystem

var tile_map: TileMapLayer
var building_grid: Dictionary = {}

func _init(layer: TileMapLayer):
	tile_map = layer

func world_to_tile(world_pos: Vector2) -> Vector2i:
	return tile_map.local_to_map(world_pos)

func tile_to_world(tile: Vector2i) -> Vector2:
	var world: Vector2 = tile_map.map_to_local(tile)
	world.x -= tile_map.tile_set.tile_size.x / 2
	world.y -= tile_map.tile_set.tile_size.y / 2
	return world

func can_place(building_type: Types.BuildingType, tile: Vector2i, is_tile_center: bool = false) -> bool:
	var building_data: BuildingData = Paths.get_building_data(building_type)

	var tiles: Array[Vector2i] = _get_footprint_tiles(building_data.footprint_size, tile, is_tile_center)
	return not tiles.any(is_tile_reserved)

func is_tile_reserved(tile: Vector2i) -> bool:
	return building_grid.has(tile)

func reserve_tiles(building: Building, anchor_tile: Vector2i, is_anchor_center: bool = false):
	var tiles: Array[Vector2i] = _get_footprint_tiles(building.footprint_size, anchor_tile, is_anchor_center)
	for tile in tiles:
		building_grid[tile] = building

func _get_footprint_tiles(footprint: Vector2i, anchor_tile: Vector2i, is_anchor_center: bool = false) -> Array[Vector2i]:
	var tiles: Array[Vector2i] = []

	var root_tile: Vector2i = Vector2i(anchor_tile)
	if is_anchor_center:
		root_tile -= footprint / 2 - (Vector2i.ONE - footprint % 2)

	for x in range(footprint.x):
		for y in range(footprint.y):
			tiles.append(root_tile + Vector2i(x, y))

	return tiles
