class_name GhostBuilding extends Node2D

var building_data: BuildingData = BuildingData.new()

var buildling_type: Types.BuildingType :
	get:
		return building_data.building_type
	set(value):
		building_data = Paths.get_building_data(value)

var top_left: Vector2i :
	get:
		return Map.instance.world_to_tile(global_position)
	set(value):
		global_position = Map.instance.tile_to_world(value)

var center: Vector2i :
	get:
		return top_left + building_data.footprint_size / 2
	set(value):
		top_left = value - (building_data.footprint_size / 2 - (Vector2i.ONE - building_data.footprint_size % 2))

func _ready() -> void:
	set_valid(true)

func set_valid(valid: bool):
	if valid:
		modulate = Color(1, 1, 1, 0.6)
	else:
		modulate = Color(1, 0.2, 0.2, 0.6)
