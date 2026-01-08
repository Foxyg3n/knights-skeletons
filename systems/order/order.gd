class_name Order extends RefCounted

var order_type: Types.OrderType

func _init(_order_type: Types.OrderType) -> void:
    order_type = _order_type