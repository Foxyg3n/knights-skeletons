extends ActionPanelBase
class_name BuildingActionPanel

@export var label_name: Label

func set_building_name(value: String) -> void:
	label_name.text = value
