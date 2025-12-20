extends Node

var command_queue: Array = []

func _ready():
    InputMode.command_ready.connect(_on_command_ready)

func _on_command_ready(cmd):
    enqueue_command(cmd)

func enqueue_command(cmd):
    command_queue.append(cmd)
    _execute_command(cmd)

func _execute_command(cmd):
    cmd.execute()
