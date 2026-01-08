class_name MoveOrder extends Order

var target_position: Vector2

func _init(_order_type: Types.OrderType, _target_position: Vector2) -> void:
    super(_order_type)
    target_position = _target_position