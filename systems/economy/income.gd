class_name Income extends Resource

@export var type: Types.ResourceType
@export var amount: int

func _init(_type: Types.ResourceType = Types.ResourceType.GOLD, _amount: int = 0) -> void:
    type = _type
    amount = _amount