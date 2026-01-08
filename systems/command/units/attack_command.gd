class_name AttackCommand extends SingleUnitCommand

var target: Targetable

func _init(_units: Array[Unit], _target: Targetable) -> void:
    super(_units)
    target = _target

func single_execute(unit: Unit) -> void:
    unit.set_order(AttackOrder.new(Types.OrderType.ATTACK, target))