class_name Map extends Node2D

static var instance: Map

@export var ground_layer: TileMapLayer
@export var grass_layer: TileMapLayer
@export var tree_layer: TileMapLayer

var grid: GridSystem
var claim_area_system: ClaimAreaSystem

func _ready() -> void:
	instance = self
	grid = GridSystem.new(ground_layer, [ tree_layer ])
	claim_area_system = ClaimAreaSystem.new()
	# TODO: Move to appropriate place
	try_place_building(Types.BuildingType.KEEP, Vector2i.ZERO, true)

func can_build(building_type: Types.BuildingType, tile: Vector2i, is_tile_center: bool = false) -> bool:
	var building_data: BuildingData = Paths.get_building_data(building_type)

	var can_place: bool = grid.can_place(building_type, tile, is_tile_center)
	var can_afford: bool = not building_data.cost or Economy.instance.can_apply_cost(building_data.cost)
	var claimable_can_place: bool = claim_area_system.can_place(building_data, tile)

	return can_place and can_afford and claimable_can_place

func try_place_building(building_type: Types.BuildingType, tile: Vector2i, is_tile_center: bool = false) -> Building:
	if not can_build(building_type, tile, is_tile_center):
		return null

	return _place_building(building_type, tile, is_tile_center)

func try_place_building_world(building_type: Types.BuildingType, world_pos: Vector2) -> Building:
	var tile: Vector2i = world_to_tile(world_pos)
	return try_place_building(building_type, tile, true)

#func try_destroy_building(building: Building) -> void:
#	if not grid.is_building_present(building):
#		return
#
#   if building.income:
#		if building.data.influence_data:
#
#	grid.free_tiles(building)
#	building.queue_free()

func tile_to_world(tile: Vector2i) -> Vector2:
	return grid.tile_to_world(tile)

func world_to_tile(world_pos: Vector2) -> Vector2i:
	return grid.world_to_tile(world_pos)

func get_tiles_in_radius(anchor: Vector2i, anchor_size: Vector2i, radius: int, influence_type: Types.InfluenceType) -> Array[Vector2i]:
	var layer: TileMapLayer = _get_influence_layer(influence_type)
	if layer == null:
		return []

	var area_root: Vector2i = anchor - Vector2i(radius, radius)
	var area_size: Vector2i = Vector2i(radius * 2 + anchor_size.x, radius * 2 + anchor_size.y)
	var tiles_in_radius: Array[Vector2i] = []
	for x in range(area_root.x, area_root.x + area_size.x):
		for y in range(area_root.y, area_root.y + area_size.y):
			var tile: Vector2i = Vector2i(x, y)

			# Exclude tiles within the anchor size
			if tile.x >= anchor.x and tile.x < anchor.x + anchor_size.x and \
			   tile.y >= anchor.y and tile.y < anchor.y + anchor_size.y:
				continue

			if layer.get_cell_tile_data(tile):
				tiles_in_radius.append(tile)

	return tiles_in_radius

func _place_building(building_type: Types.BuildingType, tile: Vector2i, is_tile_center: bool = false) -> Building:
	var building: Building = _spawn_building_scene(building_type)
	if is_tile_center:
		building.center = tile
	else:
		building.top_left = tile

	if building.cost:
		Economy.instance.apply_cost(building.cost)

	if building.income:
		Economy.instance.register_income(building.income)

	if building is ClaimingBuilding:
		claim_area_system.apply(building as ClaimingBuilding, building.top_left)

	grid.reserve_tiles(building, tile, is_tile_center)
	return building

func _spawn_building_scene(building_type: Types.BuildingType) -> Building:
	var building_scene: PackedScene = Paths.get_building_scene(building_type)
	var building: Building = building_scene.instantiate()
	add_child(building)
	return building

func _get_influence_layer(influence_type: Types.InfluenceType) -> TileMapLayer:
	match influence_type:
		Types.InfluenceType.GRASS:
			return grass_layer
		Types.InfluenceType.TREE:
			return tree_layer
		_:
			return null
