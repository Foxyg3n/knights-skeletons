extends Building

func _set_actions() -> void:
	actions[0] = load("res://ui/panels/action/buttons/build/build_tent_button.tscn")
	actions[1] = load("res://ui/panels/action/buttons/build/build_farm_button.tscn")
	actions[2] = load("res://ui/panels/action/buttons/build/build_sawmill_button.tscn")
