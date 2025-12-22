extends Building

func _ready() -> void:
    super._ready()

    actions[0] = load("res://ui/panels/action/buttons/build/build_farm_button.tscn")