extends Camera2D

@export_range(100, 300) var speed: float = 100

const zoom_speed: float = 0.1
const max_zoom: float = 2
const min_zoom: float = 0.5

func _process(delta):
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var window_size: Vector2 = get_viewport().get_visible_rect().size

	if mouse_pos.x <= 0:
		position.x -= delta * speed
	elif mouse_pos.x >= window_size.x - 1:
		position.x += delta * speed

	if mouse_pos.y <= 0:
		position.y -= delta * speed
	elif mouse_pos.y >= window_size.y - 1:
		position.y += delta * speed

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MouseButton.MOUSE_BUTTON_WHEEL_UP:
				change_zoom(zoom_speed)
			if event.button_index == MouseButton.MOUSE_BUTTON_WHEEL_DOWN:
				change_zoom(-zoom_speed)


func change_zoom(change: float):
	var next_zoom: float = clamp(zoom.x + change, min_zoom, max_zoom)
	if next_zoom == 0:
		next_zoom = 1
	zoom = Vector2(next_zoom, next_zoom)
