class_name MoveController extends RefCounted

var unit: Unit
var navigation: NavigationAgent2D
var paused: bool = false

signal move_target_reached

func _init(_unit: Unit) -> void:
    unit = _unit
    navigation = unit.get_node_or_null("NavigationAgent2D")
    navigation.target_reached.connect(func(): move_target_reached.emit())

func physics_update(delta: float) -> void:
    # FIXME: Pause movement, not the whole handling
    if paused:
        return

    if navigation.is_navigation_finished():
        unit.velocity = unit.velocity.move_toward(Vector2.ZERO, delta * 200)
        unit.move_and_slide()
        return

    var next_point: Vector2 = navigation.get_next_path_position()
    var desired: Vector2 = (next_point - unit.global_position).normalized() * unit.speed

    desired += calculate_separation()

    unit.velocity = unit.velocity.move_toward(desired, unit.acceleration * delta)
    unit.move_and_slide()

func set_move_target(target_position: Vector2) -> void:
    unit.move_target = target_position
    navigation.target_position = unit.move_target

func stop() -> void:
    navigation.target_position = unit.global_position

func pause() -> void:
    paused = true

func resume() -> void:
    paused = false

# Temporary separation behavior

func calculate_separation() -> Vector2:
    var force := Vector2.ZERO
    for other in unit.get_tree().get_nodes_in_group("units"):
        if other == unit:
            continue
        var distance: float = unit.global_position.distance_to(other.global_position)
        if distance < 24:
            force += (unit.global_position - other.global_position).normalized() * (24 - distance)
    return force * 0.5  # tuning factor