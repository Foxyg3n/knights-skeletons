class_name UnitCommand extends Command

var units: Array[Unit]

# Override (but exeute super())
func _init(selected_units: Array[Unit]):
    units = selected_units

# Optional Override (but execute super())
func is_available() -> bool:
    return not units.is_empty()

#Override
func execute() -> void:
    push_error("execute() not implemented in UnitCommand subclass")
