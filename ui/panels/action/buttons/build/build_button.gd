extends ActionButton

@export var building_type: Globals.BuildingType

func _on_press():
    InputMode.enter_build_mode(building_type)