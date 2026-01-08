class_name SingleUnitCommand extends UnitCommand

func execute() -> void:
    for unit in units:
        single_execute(unit)

# Override
func single_execute(unit: Unit) -> void:
    pass