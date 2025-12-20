extends SingleUnitCommand
class_name TargetHighHpCommand

func single_execute(unit: Unit) -> void:
#    unit.switch_targeting(Targeting.HIGH_HP)
    print("Switching to HIGH HP targetting for " + unit.get_unit_name())
