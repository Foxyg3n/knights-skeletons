extends Node2D

func _ready() -> void:
    ControlGroupSystem.enabled = true

func _exit_tree() -> void:
    ControlGroupSystem.enabled = false