class_name Building extends StaticBody2D

@export var selectable: Selectable

func _ready() -> void:
    add_to_group("building")