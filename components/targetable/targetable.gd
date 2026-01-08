class_name Targetable extends Node2D

@export var is_dead: bool = false
var is_alive: bool:
    get:
        return not is_dead
    set(value):
        is_dead = not value

func take_damage(amount: int) -> void:
    print("Targetable took %d damage" % amount)

    if is_dead:
        return

    # Forward damage to health component (not implemented here)