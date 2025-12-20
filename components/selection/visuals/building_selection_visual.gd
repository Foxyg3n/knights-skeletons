extends Node2D

@export var selectable: Selectable

func _ready() -> void:
    if not selectable:
        selectable = get_parent().get_node("Selectable")

    selectable.on_selected.connect(_on_selected)
    selectable.on_deselected.connect(_on_deselected)

func _on_selected():
    print("Selected building")

func _on_deselected():
    print("Deselected building")