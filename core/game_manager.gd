extends Node2D

enum Scene { MainMenu, Game }

@onready var game_node: Node = get_tree().get_root().get_node("Main")
#@onready var fader: Fader = game_node.find_child("Fader")
var current_scene: Node
var is_changing_scene: bool = false

signal load_scene_finished

func _ready():
	# TODO: Set mouse confined mode when in-game but not when menu is open
#	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

	load_scene.call_deferred(Scene.MainMenu)

func _input(event: InputEvent) -> void:
	pass
#	if event is InputEventKey:
#		if event.pressed and event.keycode == KEY_1:
#			load_scene(Scene.MainMenu)
#
#		elif event.pressed and event.keycode == KEY_2:
#			var tile_map: TileMapLayer  = get_tree().get_root().find_child("Ground", true, false)
#			var tile_pos: Vector2i = tile_map.local_to_map(get_global_mouse_position())
#			Debug.get_or_add_label("mouse_tile_position").text = str(tile_pos)
#
#		elif event.pressed and event.keycode == KEY_3:
#			Map.instance.try_place_building_world(Types.BuildingType.KEEP, get_global_mouse_position())
#
#		elif event.pressed and event.keycode == KEY_4:
#			InputMode.enter_build_mode(Types.BuildingType.KEEP)

func load_scene(scene_type: Scene, force: bool = false) -> void:
	var is_same_scene: bool = current_scene != null and current_scene.name == Scene.keys()[scene_type]
	if not force and (is_same_scene or is_changing_scene):
		return

	is_changing_scene = true
	
	# Unload scene
	if current_scene != null:
#		await fader.fade_in()
		game_node.remove_child(current_scene)
		current_scene.queue_free()
		
	# Load scene
	var scene_name: String = StringUtils.pascal_to_snake(Scene.keys()[scene_type])
	var scene: PackedScene = load("res://core/scenes/" + scene_name + ".tscn")
	var scene_instance: Node = scene.instantiate()
	current_scene = scene_instance
	game_node.add_child(scene_instance)
	get_tree().paused = false
#	await fader.fade_out()
	is_changing_scene = false
	load_scene_finished.emit()
