class_name Map extends Node2D

static var instance: Map

@export var ground_layer: TileMapLayer

var grid: GridSystem

func _ready() -> void:
	instance = self
	grid = GridSystem.new(ground_layer)
	# TODO: Move to appropriate place
	try_place_building(Types.BuildingType.KEEP, Vector2i.ZERO, true)

func can_build(building_type: Types.BuildingType, tile: Vector2i, is_tile_center: bool = false) -> bool:
	var building_data: BuildingData = Paths.get_building_data(building_type)
	return grid.can_place(building_type, tile, is_tile_center) and (not building_data.cost or Economy.instance.can_apply_cost(building_data.cost))

func try_place_building(building_type: Types.BuildingType, tile: Vector2i, is_tile_center: bool = false) -> Building:
	if not grid.can_place(building_type, tile, is_tile_center):
		return null

	return _place_building(building_type, tile, is_tile_center)

func try_place_building_world(building_type: Types.BuildingType, world_pos: Vector2) -> Building:
	var tile: Vector2i = world_to_tile(world_pos)

	if not grid.can_place(building_type, tile, true):
		return null

	var building_data: BuildingData = Paths.get_building_data(building_type)
	if building_data.cost and not Economy.instance.can_apply_cost(building_data.cost):
		return null

	return _place_building(building_type, tile, true)

#func try_destroy_building(building: Building) -> void:
#	if not grid.is_building_present(building):
#		return
#
#	grid.free_tiles(building)
#	building.queue_free()

func tile_to_world(tile: Vector2i) -> Vector2:
	return grid.tile_to_world(tile)

func world_to_tile(world_pos: Vector2) -> Vector2i:
	return grid.world_to_tile(world_pos)

func _place_building(building_type: Types.BuildingType, tile: Vector2i, is_tile_center: bool = false) -> Building:
	var building: Building = _spawn_building_scene(building_type)
	if is_tile_center:
		building.center = tile
	else:
		building.top_left = tile

	if building.cost:
		Economy.instance.apply_cost(building.cost)

	grid.reserve_tiles(building, tile, is_tile_center)
	return building

func _spawn_building_scene(building_type: Types.BuildingType) -> Building:
	var building_scene: PackedScene = Paths.get_building_scene(building_type)
	var building: Building = building_scene.instantiate()
	add_child(building)
	return building
