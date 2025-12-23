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
		var preselected_units: Array = preselected_selectables_cache.filter(func(selectable: Selectable): return selectable.get_parent() is Unit)
		var preselected_buildings: Array = preselected_selectables_cache.filter(func(selectable: Selectable): return selectable.get_parent() is Building)
		if not preselected_units.is_empty():
			SelectionManager.set_selection(preselected_units)
		elif not preselected_buildings.is_empty():
			SelectionManager.set_selection(preselected_buildings)
		else:
			SelectionManager.set_selection([])

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

func _exit_tree() -> void:
	preselected_selectables_cache.clear()

func _update_collision_box():
	var size: Vector2 = abs(get_global_mouse_position() - selection_start)

	var collision_top_left: Vector2 = _get_collision_top_left()
	area.global_position = collision_top_left
	collision.global_position = collision_top_left + size / 2
	var rect_collision: RectangleShape2D = collision.shape
	rect_collision.size = size

func _preselect_units():
	var area_selectables: Array = area.get_overlapping_bodies().filter(func(body): return body.selectable).map(func(body): return body.selectable)

	# New selectables
	for selectable in ArrayUtils.difference(area_selectables, preselected_selectables_cache):
		selectable.preselect()
		preselected_selectables_cache.append(selectable)

	# Old selectables
	for selectable in ArrayUtils.difference(preselected_selectables_cache, area_selectables):
		selectable.predeselect()
		preselected_selectables_cache.erase(selectable)

func _clear_preselected_selectables():
	for selectable in preselected_selectables_cache:
		selectable.predeselect()

	preselected_selectables_cache.clear()

func _get_collision_top_left() -> Vector2:
	var camera: Camera2D = get_viewport().get_camera_2d()
	var world_mouse_pos: Vector2 = SpaceUtils.screen_to_world_point(get_global_mouse_position(), camera)
	var world_selection_start: Vector2 = SpaceUtils.screen_to_world_point(selection_start, camera)
	return Vector2(min(world_selection_start.x, world_mouse_pos.x), min(world_selection_start.y, world_mouse_pos.y))
