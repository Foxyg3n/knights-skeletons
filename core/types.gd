extends Node

enum ActionPanelType { BASE, UNIT, BUILDING }
enum BuildingType { NONE, KEEP, TENT, FARM }
enum ResourceType { GOLD, WOOD, STONE, METAL, FOOD, POPULATION, HOUSING }
enum InfluenceType { TREE, GRASS }

func is_expendable_resource(resource_type: ResourceType) -> bool:
    return resource_type in [ResourceType.GOLD, ResourceType.WOOD, ResourceType.STONE, ResourceType.METAL]

func is_sustenance_resource(resource_type: ResourceType) -> bool:
    return resource_type in [ResourceType.FOOD, ResourceType.POPULATION, ResourceType.HOUSING]