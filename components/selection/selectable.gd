extends Node2D
class_name Selectable

var is_preselected: bool = false
var is_selected: bool = false

signal right_click_action(click_point: Vector2)

signal on_selected
signal on_deselected

signal on_preselected
signal on_predeselected

func preselect() -> void:
	if is_preselected: return

	is_preselected = true
	on_preselected.emit()

func predeselect() -> void:
	if not is_preselected: return

	is_preselected = false
	on_predeselected.emit()

func select() -> void:
	if is_selected: return

	is_selected = true
	on_selected.emit()

func deselect() -> void:
	if not is_selected: return

	is_selected = false
	on_deselected.emit()
