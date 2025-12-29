class_name Building extends StaticBody2D

@export var data: BuildingData

var building_name: String
var footprint_size: Vector2i
var cost: Cost
var income: Income

@export var selectable: Selectable

var actions: Dictionary = {}

var top_left: Vector2i :
	get:
		return Map.instance.world_to_tile(global_position)
	set(value):
		global_position = Map.instance.tile_to_world(value)

var center: Vector2i :
	get:
		return top_left + footprint_size / 2
	set(value):
		top_left = value - (footprint_size / 2 - (Vector2i.ONE - footprint_size % 2))

func _ready() -> void:
	add_to_group("building")

	building_name = data.building_name
	footprint_size = data.footprint_size
	cost = data.cost
	income = data.income

	_set_actions()
	# TODO: add default actions like destroy building

# Override
func _set_actions() -> void:
	pass

func _on_place() -> void:
	if income:
		Economy.instance.register_income(income)

func _on_destroy() -> void:
	if income:
		Economy.instance.unregister_income(income)