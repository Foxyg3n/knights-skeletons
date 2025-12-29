class_name ClaimingBuilding extends Building

var claimed_tiles: Array[Vector2i] = []

func set_claimed_tiles(tiles: Array[Vector2i]) -> void:
	claimed_tiles = tiles
	_recalculate_income()

func _recalculate_income() -> void:
	var claim_area: ClaimAreaData = data.claim_area
	if not claim_area:
		return

	if income:
		Economy.instance.unregister_income(income)

	var income_per_tile: Income = claim_area.income_per_tile
	income = Income.new(income_per_tile.type, income_per_tile.amount * claimed_tiles.size())
	Economy.instance.register_income(income)
