class_name Economy extends Node

static var instance: Economy

enum ExpendableResource {
    GOLD,
    WOOD,
    STONE,
    METAL,
    #CRYSTAL
}

enum SustenanceResource {
    HOUSING,
    POPULATION,
    FOOD
}

class GameResource:
    var amount: int
    var capacity: int

    func _init(_amount: int = 0, _capacity: int = 0) -> void:
        amount = _amount
        capacity = _capacity

# Expendable resources
var gold: int = 0
var wood: int = 0
var stone: int = 0
var metal: int = 0
#var crystal: int = 0

# Sustenance resources
var housing: int = 0
var population: int = 0
var food: int = 0

func _ready() -> void:
    instance = self