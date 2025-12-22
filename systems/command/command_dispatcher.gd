extends Node

var command_queue: Array = []

func enqueue_command(cmd):
	command_queue.append(cmd)
	_execute_command(cmd)

func _execute_command(cmd):
	cmd.execute()
