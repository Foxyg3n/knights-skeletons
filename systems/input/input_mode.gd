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
		# FIXME: Create util for collision queries
		var clicked_enemy: Targetable = _get_targetable_at_position(world_position)
		if clicked_enemy:
			# Attack command
			command = AttackCommand.new(selected_units, clicked_enemy)
		else:
			# Move command
			command = MoveCommand.new(selected_units, world_position)

		CommandDispatcher.enqueue_command(command)

# TODO: Think of a ghost building placement (no building, just tile highlight or building ghost on top)
func _handle_build_click(mouse_pos: Vector2):
	var building: Building = Map.instance.try_place_building_world(building_type, mouse_pos)
	if building:
		clear_mode()

func _get_targetable_at_position(world_position: Vector2) -> Targetable:
	var space: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var query: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
	query.position = world_position
	query.collide_with_areas = true
	query.collide_with_bodies = false
	var results: Array[Dictionary] = space.intersect_point(query)

	for result in results:
		var object: Node2D = result.get("collider").get_parent().get_node("Targetable")
		if object and object is Targetable:
			return object as Targetable

	return null
