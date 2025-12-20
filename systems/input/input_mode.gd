extends Node

var current_mode: String = "None"
var mode_data: Dictionary = {}

# FIXME: Why is this even a thing?
signal command_ready(command: Command)

func set_mode(mode: String, data: Dictionary = {}):
	current_mode = mode
	mode_data = data
	print("Entered mode:", mode)

func clear_mode():
	current_mode = "None"
	mode_data.clear()
	print("Exited input mode")

# TODO: Should selecting single unit be here (InputMode left-click) or in selection system (Selector left-click)
func handle_left_click(world_position: Vector2):
	pass

func handle_right_click(world_position: Vector2):
	match current_mode:
		_:
			_handle_default_right_click(world_position)

func _handle_default_right_click(world_position: Vector2) -> void:
	var selected_units: Array[Unit] = SelectionManager.get_selection_as_units()

	if selected_units.is_empty():
		return

	var command: Command
#    var clicked_unit = World.get_unit_at_position(world_position)
	if false: #clicked_unit and clicked_unit.is_enemy():
		pass
        # Attack command
#        var cmd = AttackCommand.new(selected_units, clicked_unit.global_position)
	else:
        # Move command
		command = MoveCommand.new(selected_units, world_position)

	command_ready.emit(command)