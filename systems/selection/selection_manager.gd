extends Node2D

var selected_objects: Array[Selectable] = []

signal on_selection_change

func has_selection() -> bool:
	return not selected_objects.is_empty()

func get_selection() -> Array[Selectable]:
	return selected_objects.duplicate()

func get_selection_as_units() -> Array[Unit]:
	var selected_units: Array[Unit]
	selected_units.assign(selected_objects.map(func(selectable: Selectable): return selectable.get_parent()))
	return selected_units

func set_selection(selection: Array[Selectable]):
	for selectable in selected_objects:
		selectable.deselect()

	selected_objects = _filter_selection(selection.duplicate(true))

	for selectable in selected_objects:
		selectable.select()

	on_selection_change.emit()

# TODO: implement
func _filter_selection(selection: Array[Selectable]) -> Array[Selectable]:
	return selection

#func _input(event: InputEvent) -> void:
#	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
#		handle_right_click(get_global_mouse_position())
#		for selectable in selected_objects:
#			selectable.right_click_action.emit(get_global_mouse_position())

func handle_right_click(target: Vector2) -> void:
	if selected_objects.size() == 0: return

	var selectable_type = selected_objects.front().get_parent()

	if selectable_type is Unit:
		handle_unit_command(selected_objects.map(func(selectable: Selectable): return selectable.get_parent()), target)
#	elif selectable_type is Building:
#		handle_building_command(buildings, target)

func handle_unit_command(units: Array, target: Vector2):
	# TODO: implement other actions - for now MOVE
	issue_group_move(units, target)

func issue_group_move(units: Array, target_pos: Vector2) -> void:
	if units.is_empty():
		return

	var formation_positions: Array[Vector2] = generate_target_positions(
		target_pos,
		units.size(),
		8.0  # spacing between units in pixels
	)

	units.front().move_to(target_pos)
	for i in range(1, units.size()):
		units[i].move_to(formation_positions[i])

func generate_target_positions(center: Vector2, count: int, spacing := 16.0) -> Array[Vector2]:
	var positions: Array[Vector2] = []
	var angle := 0.0
	var radius := spacing

	for i in range(count):
		positions.append(center + Vector2(radius, 0).rotated(angle))
		angle += PI / 4   # 45° steps
		if angle >= TAU:
			angle = 0
			radius += spacing  # expand outward by one ring
	return positions
