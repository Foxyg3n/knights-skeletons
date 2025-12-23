extends Node2D
class_name WorldInput

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouse:
		var world_pos: Vector2 = get_global_mouse_position()
		if event is InputEventMouseButton and event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				InputMode.handle_left_click(world_pos)
			elif event.button_index == MOUSE_BUTTON_RIGHT:
				InputMode.handle_right_click(world_pos)
		elif event is InputEventMouseMotion:
			InputMode.handle_world_motion(world_pos)
	elif event is InputEventKey:
		ControlGroupSystem.handle_input(event as InputEventKey)
		InputMode.handle_key_press(event as InputEventKey)
