class_name Projectile extends Node2D

@export var speed: float = 100.0
@export var arc_height: float = 5.0
var origin: Vector2 = Vector2.ZERO
var target: Targetable = null
var current_position: Vector2 = Vector2.ZERO

signal hit_target(target: Targetable)

func _ready() -> void:
    current_position = origin

func _process(delta: float) -> void:
    if target == null or target.is_dead:
        queue_free()
        return

    var to_target: Vector2 = target.global_position - origin
    var distance_to_target: float = to_target.length()
    var direction: Vector2 = to_target.normalized()

    var travel_distance: float = speed * delta
    current_position += direction * travel_distance

    var traveled_distance: float = current_position.distance_to(origin)
    var travel_ratio: float = traveled_distance / distance_to_target
    var height_offset: float = arc_height * 4 * travel_ratio * (1 - travel_ratio)

    global_position = current_position + Vector2(0, -height_offset)
    rotation = direction.angle()

    if traveled_distance >= distance_to_target:
        _on_hit_target()

func _on_hit_target() -> void:
    hit_target.emit(target)
    queue_free()