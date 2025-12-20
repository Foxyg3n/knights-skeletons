extends UnitCommand
class_name MoveCommand

var target_position: Vector2

func _init(selected_units: Array[Unit], position: Vector2):
    super(selected_units)
    target_position = position

func execute() -> void:
    if units.is_empty(): return

    # Calculate points

    for unit in units:
        unit.move_to(target_position)