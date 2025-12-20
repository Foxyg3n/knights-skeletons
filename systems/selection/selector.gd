extends Node2D

var selection_start: Vector2 = Vector2.ZERO
var preselected_selectables_cache: Array[Selectable] = []

@onready var area: Area2D = $Area2D
@onready var collision: CollisionShape2D = $Area2D/CollisionShape2D

func _unhandled_input(event: InputEvent) -> void:
	# Start selecting
	if selection_start == Vector2.ZERO and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		selection_start = get_global_mouse_position()
	# End selecting
	elif selection_start != Vector2.ZERO and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		selection_start = Vector2.ZERO
		SelectionManager.set_selection(preselected_selectables_cache)
		_clear_preselected_selectables()
	# Selecting
	elif selection_start != Vector2.ZERO and event is InputEventMouseMotion:
		_update_collision_box()
		_preselect_units()

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	if selection_start == Vector2.ZERO: return

	var mouse_pos: Vector2 = get_global_mouse_position()
	var select_box: Rect2 = Rect2(selection_start, mouse_pos - selection_start)

	draw_rect(select_box, Color("#ffffff33"))
	draw_rect(select_box, Color("#ffffff"), false, 0.2)

func _update_collision_box():
	var size: Vector2 = abs(get_global_mouse_position() - selection_start)

	var collision_top_left: Vector2 = _get_collision_top_left()
	area.global_position = collision_top_left
	collision.global_position = collision_top_left + size / 2
	var rect_collision: RectangleShape2D = collision.shape
	rect_collision.size = size

func _preselect_units():
	var units_in_scene: Array = get_tree().get_nodes_in_group("unit")
	var buildings_in_scene: Array = get_tree().get_nodes_in_group("building")
	var area_units: Array = area.get_overlapping_bodies().filter(func(body): return body in units_in_scene)
	var area_buildings: Array = area.get_overlapping_bodies().filter(func(body): return body in buildings_in_scene)

	# FIXME: area_buildings != preselected_selectables_cache
	for building in ArrayUtils.difference(area_buildings, preselected_selectables_cache):
		building.selectable.preselect()
		preselected_selectables_cache.append(building.selectable)

	# New units
#	for unit in ArrayUtils.difference(area_units, preselected_units_cache):
#		unit.selectable.preselect()
#		preselected_units_cache.append(unit)

	# Removed units
#	for unit in ArrayUtils.difference(preselected_units_cache, area_units):
#		unit.selectable.predeselect()
#		preselected_units_cache.erase(unit)

func _clear_preselected_selectables():
	for selectable in preselected_selectables_cache:
		selectable.predeselect()

	preselected_selectables_cache.clear()

func _get_collision_top_left() -> Vector2:
	var camera: Camera2D = get_viewport().get_camera_2d()
	var world_mouse_pos: Vector2 = SpaceUtils.screen_to_world_point(get_global_mouse_position(), camera)
	var world_selection_start: Vector2 = SpaceUtils.screen_to_world_point(selection_start, camera)
	return Vector2(min(world_selection_start.x, world_mouse_pos.x), min(world_selection_start.y, world_mouse_pos.y))
