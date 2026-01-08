extends CharacterBody2D
class_name Unit

@export var speed: float = 20
@export var acceleration: float = 100
@export var unit_name: String = "Janek"

@export var selectable: Selectable

var force_moving: bool = false
var move_target: Vector2 = Vector2.ZERO
var target: Targetable = null

@onready var controller: UnitController = UnitController.new(self)
@onready var combat_controller: CombatController = CombatController.new(self)
@onready var move_controller: MoveController = MoveController.new(self)

func _ready() -> void:
	add_to_group("unit")

func _process(delta) -> void:
#	combat_controller.update(delta)
	controller.update(delta)

func _physics_process(delta) -> void:
	move_controller.physics_update(delta)
	controller.physics_update(delta)

#func move_to(target: Vector2):
#	navigation.target_position = target

func set_order(order: Order) -> void:
	controller.set_order(order)
