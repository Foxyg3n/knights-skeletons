extends UnitCommand
class_name SingleUnitCommand

func execute() -> void:
    for unit in units:
        single_execute(unit)

# Override
func single_execute(unit: Unit) -> void:
    pass