class_name GhostBuilding extends Node2D

@export var sprite: Sprite2D

var building_data: BuildingData = BuildingData.new()

var buildling_type: Types.BuildingType :
	get:
		return building_data.building_type
	set(value):
		building_data = Paths.get_building_data(value)
		_update_sprite()

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

func set_valid(valid: bool):
	if valid:
		sprite.modulate = Color(1, 1, 1, 0.6)
	else:
		sprite.modulate = Color(1, 0.2, 0.2, 0.6)

func _update_sprite() -> void:
	var current_color: Color = sprite.modulate
	sprite.texture = building_data.texture
	sprite.position = building_data.texture.get_size() / 2
	sprite.modulate = current_color