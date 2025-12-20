extends Control
class_name ActionPanelBase

@onready var background: TextureRect = $Background

func _ready() -> void:
	background.visible = false

func get_action_buttons() -> Array[ActionButton]:
	var action_buttons: Array[ActionButton]
	action_buttons.assign($HUD/ActionButtons.get_children())
	return action_buttons

# Override
func set_hud_selection(selection: Array):
	pass

# Override
func update_info():
	pass
