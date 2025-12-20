extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@export var selectable: Selectable

func _ready() -> void:
	if not selectable:
		selectable = get_parent().get_node("Selectable")

	selectable.on_selected.connect(_on_selected)
	selectable.on_deselected.connect(_on_deselected)
	sprite.visible = false

func _on_selected():
	sprite.visible = true

func _on_deselected():
	sprite.visible = false
