extends Node2D

func _ready() -> void:
	ControlGroupSystem.enabled = true

func _exit_tree() -> void:
	ControlGroupSystem.clear_groups()
	ControlGroupSystem.enabled = false
	SelectionManager.clear_selection_silently()
