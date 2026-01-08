class_name CombatController extends RefCounted

var unit: Unit
var attack_component: AttackComponent

func _init(_unit: Unit) -> void:
    unit = _unit
    attack_component = unit.get_node_or_null("AttackComponent")

func update() -> void:
    if can_attack():
        attack_component.attack(unit.target)

func has_target() -> bool:
    return unit.target != null and not unit.target.is_dead

func can_attack() -> bool:
    if attack_component == null or unit.target == null:
        return false

    return attack_component.can_attack(unit.target)

func can_reach() -> bool:
    return attack_component.can_reach(unit.target)

func _acquire_target() -> void:
    pass
