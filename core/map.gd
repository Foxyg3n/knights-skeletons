class_name Map extends Node2D

static var instance: Map

@export var ground_layer: TileMapLayer

var grid: GridSystem

func _ready() -> void:
	instance = self
	grid = GridSystem.new(ground_layer)
	# TODO: Move to appropriate place
	try_place_building(Globals.BuildingType.KEEP, Vector2i.ZERO, true)

func try_place_building(building_type: Globals.BuildingType, tile: Vector2i, is_tile_center: bool = false) -> Building:
	if not grid.can_place(building_type, tile, is_tile_center):
		return null

	return _place_building(building_type, tile, is_tile_center)

func try_place_building_world(building_type: Globals.BuildingType, world_pos: Vector2) -> Building:
	var tile: Vector2i = world_to_tile(world_pos)

	if not grid.can_place(building_type, tile, true):
		return null

	return _place_building(building_type, tile, true)

func can_place(building_type: Globals.BuildingType, tile: Vector2i, is_tile_center: bool = false) -> bool:
	return grid.can_place(building_type, tile, is_tile_center)

func tile_to_world(tile: Vector2i) -> Vector2:
	return grid.tile_to_world(tile)

func world_to_tile(world_pos: Vector2) -> Vector2i:
	return grid.world_to_tile(world_pos)

func _place_building(building_type: Globals.BuildingType, tile: Vector2i, is_tile_center: bool = false) -> Building:
	var building: Building = _spawn_building_scene(building_type)
	if is_tile_center:
		building.center = tile
	else:
		building.top_left = tile

	grid.reserve_tiles(building, tile, is_tile_center)
	return building

func _spawn_building_scene(building_type: Globals.BuildingType) -> Building:
	var building_scene_path: String = Globals.BuildingScenes.get(building_type)
	var building_scene: PackedScene = load(building_scene_path)
	var building: Building = building_scene.instantiate()
	add_child(building)
	return building
