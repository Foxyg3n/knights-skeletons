extends Node2D

@export var selectable: Selectable
@export var building: Building

var should_draw: bool = false

func _ready() -> void:
    if not selectable:
        selectable = get_parent().get_node("Selectable")

    if not building:
        building = get_parent()

    selectable.on_selected.connect(_on_selected)
    selectable.on_deselected.connect(_on_deselected)

func _on_selected():
    should_draw = true

func _on_deselected():
    should_draw = false

func _process(_delta: float) -> void:
    queue_redraw()

func _draw() -> void:
    if should_draw:
        draw_rect(Rect2(0, 0, building.footprint_size.x * 8, building.footprint_size.y * 8), Color.WHITE, false, 0.5)