class_name AttackOrder extends Order

var target: Targetable

func _init(_order_type: Types.OrderType, _target: Targetable) -> void:
    super(_order_type)
    target = _target
