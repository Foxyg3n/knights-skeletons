class_name HealthComponent extends Node2D

@export var max_health: int = 100

var current_health: int = max_health
var is_dead: bool = false

func take_damage(amount: int) -> void:
    current_health -= amount
    if current_health <= 0:
        current_health = 0
        _on_death()

func _on_death() -> void:
    is_dead = true
    # TODO: Handle death logic here (e.g., emit signal, play animation, etc.)