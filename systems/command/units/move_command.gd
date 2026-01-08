class_name MoveCommand extends UnitCommand

var target_position: Vector2

func _init(selected_units: Array[Unit], position: Vector2):
    super(selected_units)
    target_position = position

func execute() -> void:
    if units.is_empty(): return

    # TODO: Calculate points

    for unit in units:
        unit.set_order(MoveOrder.new(Types.OrderType.MOVE, target_position))