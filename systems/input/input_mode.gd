extends Node2D

enum Mode {
	NORMAL,
	BUILD
}

var current_mode: Mode = Mode.NORMAL

# Building Mode
var building_type: Types.BuildingType = Types.BuildingType.NONE
var ghost_building: GhostBuilding

func enter_build_mode(type: Types.BuildingType) -> void:
	if type == Types.BuildingType.NONE:
		return
		
	building_type = type
	current_mode = Mode.BUILD

	var tile: Vector2i = Map.instance.world_to_tile(get_global_mouse_position())

	if ghost_building:
		ghost_building.buildling_type = building_type
	else:
		ghost_building = load("res://systems/ghost_building/ghost_building.tscn").instantiate()
		ghost_building.buildling_type = building_type

		ghost_building.center = tile

		Map.instance.add_child(ghost_building)

	var can_build: bool = Map.instance.can_build(building_type, tile, true)
	ghost_building.set_valid(can_build)


func clear_mode():
	# Clean building mode
	building_type = Types.BuildingType.NONE
	if ghost_building:
		ghost_building.queue_free()
		ghost_building = null

	current_mode = Mode.NORMAL

func handle_left_click(world_pos: Vector2):
	match current_mode:
		Mode.NORMAL:
			pass
		Mode.BUILD:
			_handle_build_click(world_pos)

func handle_right_click(world_pos: Vector2):
	match current_mode:
		Mode.NORMAL:
			_handle_default_right_click(world_pos)
		Mode.BUILD:
			clear_mode()

func handle_world_motion(world_pos: Vector2) -> void:
	if current_mode != Mode.BUILD:
		return

	var tile: Vector2i = Map.instance.world_to_tile(world_pos)
	ghost_building.center = tile

	var can_build: bool = Map.instance.can_build(building_type, tile, true)
	ghost_building.set_valid(can_build)

func handle_key_press(event: InputEventKey):
	if event.pressed and not event.echo:
		match current_mode:
			Mode.NORMAL:
				if event.is_action_pressed("ui_cancel"):
					PauseMenu.instance.show_menu()
			Mode.BUILD:
				if event.is_action_pressed("ui_cancel"):
					clear_mode()

func _handle_default_right_click(world_position: Vector2) -> void:
	if SelectionManager.is_selection_units():
		var selected_units: Array[Unit] = SelectionManager.get_selection_as_units()

		var command: Command
	#    var clicked_unit = World.get_unit_at_position(world_position)
		if false: #clicked_unit and clicked_unit.is_enemy():
			pass
			# Attack command
	#        var cmd = AttackCommand.new(selected_units, clicked_unit.global_position)
		else:
			# Move command
			command = MoveCommand.new(selected_units, world_position)

		CommandDispatcher.enqueue_command(command)

func _handle_build_click(mouse_pos: Vector2):
	var building: Building = Map.instance.try_place_building_world(building_type, mouse_pos)
	if building:
		clear_mode()
