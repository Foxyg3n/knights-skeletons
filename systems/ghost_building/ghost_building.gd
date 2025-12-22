class_name GhostBuilding extends Node2D

# setter -> set building data and sprite
var buildling_type: Globals.BuildingType

# TODO: Get rid of ASAP
func _get_footprint_size() -> Vector2i:
	var building_scene: PackedScene = load(Globals.BuildingScenes.get(buildling_type))
	var building: Building = building_scene.instantiate()
	return building.footprint_size

var top_left: Vector2i :
	get:
		return Map.instance.world_to_tile(global_position)
	set(value):
		global_position = Map.instance.tile_to_world(value)

var center: Vector2i :
	get:
		var footprint_size: Vector2i = _get_footprint_size()
		return top_left + footprint_size / 2
	set(value):
		var footprint_size: Vector2i = _get_footprint_size()
		top_left = value - (footprint_size / 2 - (Vector2i.ONE - footprint_size % 2))

func set_valid(valid: bool):
	if valid:
		modulate = Color(1, 1, 1, 0.6)
	else:
		modulate = Color(1, 0.2, 0.2, 0.6)
