extends CharacterBody2D
class_name Unit

@export var speed: float = 20
@export var acceleration: float = 100
@export var unit_name: String = "Janek"

var force_moving: bool = false
var move_target: Vector2 = Vector2.ZERO

@export var selectable: Selectable
@export var navigation: NavigationAgent2D

func _ready() -> void:
	add_to_group("unit")
	selectable.right_click_action.connect(move_to)

func _physics_process(delta) -> void:
	if navigation.is_navigation_finished():
		velocity = velocity.move_toward(Vector2.ZERO, delta * 200)
		move_and_slide()
		return

	var next_point: Vector2 = navigation.get_next_path_position()
	var desired: Vector2 = (next_point - global_position).normalized() * speed

	desired += calculate_separation()

	velocity = velocity.move_toward(desired, acceleration * delta)
	move_and_slide()

func calculate_separation() -> Vector2:
	var force := Vector2.ZERO
	for other in get_tree().get_nodes_in_group("units"):
		if other == self: continue
		var distance: float = global_position.distance_to(other.global_position)
		if distance < 24:
			force += (global_position - other.global_position).normalized() * (24 - distance)
	return force * 0.5  # tuning factor

func move_to(target: Vector2):
	navigation.target_position = target
