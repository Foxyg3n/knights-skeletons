class_name UnitController extends RefCounted

var unit: Unit
var current_order: Order = null

func _init(_unit: Unit) -> void:
    unit = _unit

func set_order(order: Order) -> void:
    if current_order != null:
        _exit_order(current_order)

    current_order = order

    if current_order != null:
        _enter_order(current_order)

func update(_delta: float) -> void:
    if current_order == null:
        return

    match current_order.order_type:
        Types.OrderType.MOVE:
            pass
        Types.OrderType.ATTACK:
            _tick_attack(current_order as AttackOrder)
        _:
            pass

func physics_update(delta: float) -> void:
    if current_order == null:
        return

    match current_order.order_type:
        Types.OrderType.MOVE:
            _tick_move(current_order as MoveOrder, delta)
        Types.OrderType.ATTACK:
            pass
        _:
            pass

func _enter_order(order: Order) -> void:
    match order.order_type:
        Types.OrderType.MOVE:
            _enter_move(order as MoveOrder)
        Types.OrderType.ATTACK:
            _enter_attack(order as AttackOrder)
        _:
            pass

func _exit_order(order: Order) -> void:
    match order.order_type:
        Types.OrderType.MOVE:
            _exit_move(order as MoveOrder)
        Types.OrderType.ATTACK:
            _exit_attack(order as AttackOrder)
        _:
            pass

# States

func _enter_move(order: MoveOrder) -> void:
    unit.move_controller.set_move_target(order.target_position)
    unit.move_controller.resume()
    if not unit.move_controller.move_target_reached.is_connected(_on_move_order_reached):
        unit.move_controller.move_target_reached.connect(_on_move_order_reached)

func _tick_move(_order: MoveOrder, delta: float) -> void:
    pass

func _exit_move(_order: MoveOrder) -> void:
    unit.move_controller.stop()
    if unit.move_controller.move_target_reached.is_connected(_on_move_order_reached):
        unit.move_controller.move_target_reached.disconnect(_on_move_order_reached)

func _on_move_order_reached() -> void:
    set_order(null)

func _enter_attack(order: AttackOrder) -> void:
    unit.target = order.target
    unit.move_controller.set_move_target(order.target.global_position)

func _tick_attack(_order: AttackOrder) -> void:
    if unit.target.is_alive:
        if unit.combat_controller.can_reach():
            unit.move_controller.pause()
            unit.combat_controller.update()
        else:
            unit.move_controller.resume()
            unit.move_controller.set_move_target(unit.target.global_position)
    else:
        set_order(null)

func _exit_attack(_order: AttackOrder) -> void:
    unit.target = null