class_name Economy extends Node

const REFUND_FACTOR: float = 0.75

static var instance: Economy

@export var gold_income_interval: TimeUnit
@export var wood_income_interval: TimeUnit

# Expendable resources
var gold: GameResource = GameResource.new(500, 5000, true)
var wood: GameResource = GameResource.new(20, 50, true)
var stone: GameResource = GameResource.new(50, 50, true)
var metal: GameResource = GameResource.new(50, 50, true)
#var crystal: GameResource = GameResource.new(0, 0, true)

# Sustenance resources
var housing: GameResource = GameResource.new(50, 50, false)
var population: GameResource = GameResource.new(50 * 2, 50 * 2, false)
var food: GameResource = GameResource.new(50, 50, false)

var registered_incomes: Array[Income] = []

var gold_income_timer: Timer
var wood_income_timer: Timer

func _ready() -> void:
	instance = self

	gold_income_timer = _create_tick_timer(gold_income_interval)
	gold_income_timer.timeout.connect(func(): _generate_income(Types.ResourceType.GOLD))

	wood_income_timer = _create_tick_timer(wood_income_interval)
	wood_income_timer.timeout.connect(func(): _generate_income(Types.ResourceType.WOOD))

# FIXME: Debug income
func _process(_delta: float) -> void:
	Debug.get_or_add_label("gold").text = "Gold: %d" % gold.available()
	Debug.get_or_add_label("wood").text = "Wood: %d" % wood.available()
	Debug.get_or_add_label("food").text = "Food: %d" % food.available()

func can_apply_cost(cost: Cost) -> bool:
	for resource_type in cost.expendable.keys() + cost.sustenance.keys():
		var amount: int = cost.get_resource_amount(resource_type)
		var resource: GameResource = _get_resource_by_type(resource_type)
		if resource.available() < amount:
			return false
	return true

func get_available(resource_type: Types.ResourceType) -> int:
	return _get_resource_by_type(resource_type).available()

func apply_cost(cost: Cost) -> void:
	for resource_type in cost.expendable.keys() + cost.sustenance.keys():
		var amount: int = cost.get_resource_amount(resource_type)
		var resource: GameResource = _get_resource_by_type(resource_type)
		if resource.is_expendable:
			resource.total -= amount
		else:
			resource.used += amount

func release_cost(cost: Cost) -> void:
	for resource_type in cost.expendable.keys() + cost.sustenance.keys():
		var amount: int = cost.get_resource_amount(resource_type)
		var resource: GameResource = _get_resource_by_type(resource_type)
		if resource.is_expendable:
			resource.total += int(amount * REFUND_FACTOR)
		else:
			resource.used -= amount

func register_income(income: Income) -> void:
	if _is_resource_expendable(income.type):
		registered_incomes.append(income)
	else:
		var resource: GameResource = _get_resource_by_type(income.type)
		resource.total += income.amount

func unregister_income(income: Income) -> void:
	if income in registered_incomes:
		registered_incomes.erase(income)
	else:
		var resource: GameResource = _get_resource_by_type(income.type)
		resource.total -= income.amount

func _generate_income(resource_type: Types.ResourceType) -> void:
	var resource: GameResource = _get_resource_by_type(resource_type)
	var income_amount: int = _get_resource_income_by_type(resource_type)
	resource.total += income_amount

func _create_tick_timer(interval: TimeUnit) -> Timer:
	var timer: Timer = Timer.new()
	timer.wait_time = interval.seconds
	timer.one_shot = false
	add_child(timer)
	timer.start()
	return timer

func _get_resource_by_type(resource_type: Types.ResourceType) -> GameResource:
	match resource_type:
		Types.ResourceType.GOLD:
			return gold
		Types.ResourceType.WOOD:
			return wood
		Types.ResourceType.STONE:
			return stone
		Types.ResourceType.METAL:
			return metal
		Types.ResourceType.HOUSING:
			return housing
		Types.ResourceType.POPULATION:
			return population
		Types.ResourceType.FOOD:
			return food
		_:
			push_error("Unknown resource type: %s" % str(resource_type))
			return null

func _get_resource_income_by_type(resource_type: Types.ResourceType) -> int:
	var incomes: Array = registered_incomes.filter(func(income: Income): return income.type == resource_type).map(func(income: Income): return income.amount)
	return ArrayUtils.sum(incomes)

func _is_resource_expendable(resource_type: Types.ResourceType) -> bool:
	match resource_type:
		Types.ResourceType.GOLD, Types.ResourceType.WOOD, Types.ResourceType.STONE, Types.ResourceType.METAL:
			return true
		Types.ResourceType.HOUSING, Types.ResourceType.POPULATION, Types.ResourceType.FOOD:
			return false
		_:
			push_error("Unknown resource type: %s" % str(resource_type))
			return false
