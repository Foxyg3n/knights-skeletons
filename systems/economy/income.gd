class_name Income extends Resource

@export var type: Types.ResourceType
@export var amount: int

func _init(income_type: Types.ResourceType = Types.ResourceType.GOLD, income_amount: int = 0) -> void:
	type = income_type
	amount = income_amount
