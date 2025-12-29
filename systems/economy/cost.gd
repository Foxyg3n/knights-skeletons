class_name Cost extends Resource

@export var resources: Dictionary[Types.ResourceType, int] = {}

func _init(cost_resources: Dictionary[Types.ResourceType, int] = {}) -> void:
	resources = cost_resources

func get_expendable_resources() -> Dictionary[Types.ResourceType, int]:
	var expendable: Dictionary[Types.ResourceType, int] = {}
	for resource_type in resources.keys():
		if Types.is_expendable_resource(resource_type):
			expendable[resource_type] = resources[resource_type]
	return expendable

func get_sustenance_resources() -> Dictionary[Types.ResourceType, int]:
	var sustenance: Dictionary[Types.ResourceType, int] = {}
	for resource_type in resources.keys():
		if Types.is_sustenance_resource(resource_type):
			sustenance[resource_type] = resources[resource_type]
	return sustenance

func get_resource_amount(resource_type: Types.ResourceType) -> int:
	var expendable: Dictionary[Types.ResourceType, int] = get_expendable_resources()
	var sustenance: Dictionary[Types.ResourceType, int] = get_sustenance_resources()
	if resource_type in expendable:
		return expendable[resource_type]
	elif resource_type in sustenance:
		return sustenance[resource_type]
	return 0
