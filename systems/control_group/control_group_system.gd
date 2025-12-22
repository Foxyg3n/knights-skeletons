extends Node

var enabled: bool = false
var groups: Dictionary = {}

func assign_group(index: int):
    if SelectionManager.has_selection():
        groups[index] = SelectionManager.get_selection()

func recall_group(index: int):
    if groups.has(index):
        SelectionManager.set_selection(groups.get(index))

func handle_input(event: InputEventKey) -> void:
    if not enabled:
        return

    if event.pressed and not event.echo:
        var group: int = _key_to_group(event.keycode)
        if group == -1:
            return

        if event.ctrl_pressed:
            assign_group(group)
        else:
            recall_group(group)

func _key_to_group(keycode: Key) -> int:
    match keycode:
        KEY_1: return 1
        KEY_2: return 2
        KEY_3: return 3
        KEY_4: return 4
        KEY_5: return 5
        KEY_6: return 6
        KEY_7: return 7
        KEY_8: return 8
        KEY_9: return 9
        KEY_0: return 0
        _: return -1