extends ActionPanelBase
class_name BuildingActionPanel

@export var building_name_label: Label

var buildings: Array[Building] = []

func set_hud_selection(selection: Array):
	buildings.assign(selection)

func set_building_name(value: String) -> void:
	building_name_label.text = value

func update_info():
	var building: Building = buildings.front()

	set_action_buttons(building.actions)
	set_building_name(building.building_name)
