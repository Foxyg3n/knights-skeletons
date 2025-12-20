extends Node

enum ActionPanelType { BASE, UNIT, BUILDING }

const ActionPanelScenes: Dictionary = {
    ActionPanelType.BASE: "res://ui/panels/action/action_panel_base.tscn",
    ActionPanelType.UNIT: "res://ui/panels/action/unit_action_panel.tscn",
    ActionPanelType.BUILDING: "res://ui/panels/action/building_action_panel.tscn"
}