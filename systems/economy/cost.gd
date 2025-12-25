class_name Cost extends Resource

@export var expendable: Dictionary[Types.ResourceType, int] = {}
@export var sustenance: Dictionary[Types.ResourceType, int] = {}

func _init(_expendable: Dictionary[Types.ResourceType, int] = {}, _sustenance: Dictionary[Types.ResourceType, int] = {}) -> void:
	expendable = _expendable
	sustenance = _sustenance

func get_resource_amount(resource_type: Types.ResourceType) -> int:
	if resource_type in expendable:
		return expendable[resource_type]
	elif resource_type in sustenance:
		return sustenance[resource_type]
	return 0
