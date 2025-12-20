extends ActionPanelBase
class_name UnitActionPanel

var units: Array[Unit] = []

@onready var unit_name_label: Label = $HUD/UnitNameLabel

func set_hud_selection(selection: Array):
	units.assign(selection)

func set_unit_name(unit_name: String):
	unit_name_label.text = unit_name

func update_info():
	var unit: Unit = units.front()

	set_unit_name(unit.get_unit_name())
