class_name PauseMenu extends Control

static var instance: PauseMenu

func _ready():
    instance = self
    visible = false

func _unhandled_input(event: InputEvent) -> void:
    if not visible:
        return

    if event is InputEventKey and event.pressed and not event.echo:
        if event.is_action_pressed("ui_cancel"):
            hide_menu()
            get_viewport().set_input_as_handled()

func show_menu():
    visible = true
    get_tree().paused = true

func hide_menu():
    visible = false
    get_tree().paused = false

func _on_resume_pressed():
    hide_menu()

func _on_quit_to_menu_pressed():
    GameManager.load_scene(GameManager.Scene.MainMenu)