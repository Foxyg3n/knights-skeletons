@tool
class_name TimeUnit extends Resource

@export var milliseconds: int
@export var seconds: float :
    get:
        return milliseconds / 1000.0
    set(value):
        milliseconds = int(value * 1000)
@export var minutes: float :
    get:
        return seconds / 60.0
    set(value):
        seconds = value * 60.0
@export var hours: float :
    get:
        return minutes / 60.0
    set(value):
        minutes = value * 60.0

func _init(_milliseconds: int = 0) -> void:
    milliseconds = _milliseconds

static func from_seconds(value: float) -> TimeUnit:
    var time_unit: TimeUnit = TimeUnit.new()
    time_unit.seconds = value
    return time_unit

static func from_minutes(value: float) -> TimeUnit:
    var time_unit: TimeUnit = TimeUnit.new()
    time_unit.minutes = value
    return time_unit

static func from_hours(value: float) -> TimeUnit:
    var time_unit: TimeUnit = TimeUnit.new()
    time_unit.hours = value
    return time_unit