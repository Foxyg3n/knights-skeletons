extends Node

const BUILDING_DATA_PATH: String = "res://data/buildings/"
const BUILDING_SCENE_PATH: String = "res://entities/buildings/"
const ACTION_PANEL_PATH: String = "res://ui/panels/action/"

# TODO: Can do caches for loaded resources in the future

func get_building_scene(building_type: Types.BuildingType) -> PackedScene:
    var name: String = Types.BuildingType.keys()[building_type].to_lower()
    return load(BUILDING_SCENE_PATH + name + "/" + name + ".tscn")

func get_building_data(building_type: Types.BuildingType) -> BuildingData:
    var name: String = Types.BuildingType.keys()[building_type].to_lower()
    return load(BUILDING_DATA_PATH + name + ".tres")

func get_action_panel_scene(panel_type: Types.ActionPanelType) -> PackedScene:
    var name: String = Types.ActionPanelType.keys()[panel_type].to_lower()
    return load(ACTION_PANEL_PATH + name + "_action_panel.tscn")