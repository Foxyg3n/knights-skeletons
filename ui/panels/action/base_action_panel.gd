extends Control
class_name ActionPanelBase

@onready var background: TextureRect = $Background
@onready var actions_buttons_container: Control = $HUD/ActionButtons


func _ready() -> void:
	background.visible = false

func get_action_buttons() -> Array[ActionButton]:
	var action_buttons: Array[ActionButton]
	action_buttons.assign(actions_buttons_container.get_children())
	return action_buttons

func set_action_buttons(actions: Dictionary):
	var action_buttons: Array[PackedScene] = []
	for i in range(12):
		if actions.has(i):
			action_buttons.append(actions.get(i))
		else:
			action_buttons.append(load("res://ui/panels/action/buttons/action_button.tscn"))

	for action_button_scene in action_buttons:
		actions_buttons_container.add_child(action_button_scene.instantiate())

# Override
func set_hud_selection(selection: Array):
	pass

# Override
func update_info():
	pass
