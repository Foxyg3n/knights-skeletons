class_name GameResource extends Resource

var total: int = 0
var used: int = 0
var capacity: int = int(INF)
var is_expendable: bool = true

func _init(_total: int, _capacity: int, _is_expendable: bool) -> void:
    total = _total
    capacity = _capacity
    is_expendable = _is_expendable

func available() -> int:
    return total - used