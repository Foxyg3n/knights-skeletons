extends Control
class_name ActionHud

static var instance: ActionHud

var panel: ActionPanelBase = null

func _ready() -> void:
	instance = self
	SelectionManager.on_selection_change.connect(handle_selection_change)
	# TODO: Change to capitol Hud when it's done
	change_action_panel(Globals.ActionPanelType.BASE, [])

func handle_selection_change() -> void:
	var selection: Array[Selectable] = SelectionManager.selected_objects

	if selection.is_empty():
		change_action_panel(Globals.ActionPanelType.BASE, [])
		return

	# Unit selection
	if selection.all(func(selectable: Selectable): return selectable.get_parent() is Unit):
		# Same type units:
		# TODO: Check actual type instead of unit name
		if ArrayUtils.trait_matches(selection, func(selectable: Selectable): selectable.get_parent().unit_name):
			change_action_panel(Globals.ActionPanelType.UNIT, selection)
		# Different type units:
		else:
			pass

func change_action_panel(panel_type: Globals.ActionPanelType, selection: Array):
	# Unload action panel
	if panel != null:
		remove_child(panel)
		panel.queue_free()
		panel = null

	# Load new action panel
	var new_panel: ActionPanelBase = load(Globals.ActionPanelScenes[panel_type]).instantiate() as ActionPanelBase
	add_child(new_panel)
	new_panel.set_hud_selection(selection.map(func(selectable: Selectable): return selectable.get_parent()))
	new_panel.update_info()
	panel = new_panel
	for button in panel.get_action_buttons():
		button.action_requested.connect(_on_action_button_pressed)

func _on_action_button_pressed(action_id: String, action_data: Dictionary):
	if action_id in [ "HighHpTargeting" ]:
		# execute command
		# Test
		var command: Command = TargetHighHpCommand.new(SelectionManager.get_selection_as_units())
		CommandDispatcher.enqueue_command(command)
	else:
#		InputMode.set_mode(action_id, action_data)
		pass
