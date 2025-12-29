class_name ClaimAreaSystem extends Node

var claimed_tiles: Dictionary = {} # [Vector2i, Types.InfluenceType]

func can_place(building_data: BuildingData, anchor: Vector2i) -> bool:
    if not building_data.claim_area:
        return true

    var claim_area: ClaimAreaData = building_data.claim_area
    var tiles: Array[Vector2i] = Map.instance.get_tiles_in_radius(anchor, building_data.footprint_size, claim_area.radius, claim_area.type)

    var area_overlaps: bool = tiles.any(func(tile: Vector2i) -> bool: return tile in claimed_tiles)
    return not tiles.is_empty() and not area_overlaps

func apply(building: ClaimingBuilding, anchor: Vector2i) -> void:
    var claim_area: ClaimAreaData = building.data.claim_area
    if not claim_area:
        return

    var tiles: Array[Vector2i] = Map.instance.get_tiles_in_radius(anchor, building.data.footprint_size, claim_area.radius, claim_area.type)
    for tile in tiles:
        claimed_tiles[tile] = building
        # Map claim tile visuals can be added here like Map.instance.apply_claim_tile(tile, claim_area.type)

    building.set_claimed_tiles(tiles)

func release() -> void:
    # Placeholder implementation
    pass

func on_tile_overwrite(tile: Vector2i) -> void:
    # Placeholder implementation
    pass