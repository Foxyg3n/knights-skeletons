extends ActionButton

@export var building_type: Types.BuildingType

func _on_press():
    InputMode.enter_build_mode(building_type)