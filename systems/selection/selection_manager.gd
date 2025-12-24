extends Node2D

var selected_objects: Array[Selectable] = []

signal on_selection_change

func has_selection() -> bool:
	return not selected_objects.is_empty()

func get_selection() -> Array[Selectable]:
	return selected_objects.duplicate()

func is_selection_units() -> bool:
	return selected_objects.all(func(selectable: Selectable): return selectable.get_parent() is Unit)

func is_selection_buildings() -> bool:
	return selected_objects.all(func(selectable: Selectable): return selectable.get_parent() is Building)

func get_selection_as_units() -> Array[Unit]:
	var selected_units: Array[Unit]
	selected_units.assign(selected_objects.map(func(selectable: Selectable): return selectable.get_parent()))
	return selected_units

func get_selection_as_buildings() -> Array[Building]:
	var selected_buildings: Array[Building]
	selected_buildings.assign(selected_objects.map(func(selectable: Selectable): return selectable.get_parent()))
	return selected_buildings

func set_selection(selection: Array[Selectable]):
	for selectable in selected_objects:
		selectable.deselect()

	selected_objects = selection.duplicate(true)

	for selectable in selected_objects:
		selectable.select()

	on_selection_change.emit()

func clear_selection_silently():
	selected_objects.clear()