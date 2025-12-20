extends TextureButton
class_name ActionButton

@export var action_id: StringName
@export var action_data := {}

signal action_requested(action_id: StringName, action_data: Dictionary)

func _ready() -> void:
	pressed.connect(func(): action_requested.emit(action_id, action_data))
