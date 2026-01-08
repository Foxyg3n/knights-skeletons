class_name AttackComponent extends Node2D

@export var attack_range: float = 5.0
@export var damage: int = 10
@export var attack_speed: float = 1.0
@export var attack_type: Types.AttackType = Types.AttackType.HITSCAN
@export var projectile_scene: PackedScene = null

var attack_cooldown_ready: bool = true

func can_reach(target: Targetable) -> bool:
	return global_position.distance_to(target.global_position) <= attack_range

func can_attack(taget: Targetable) -> bool:
	return attack_cooldown_ready and can_reach(taget)

# TODO: Implement animations and let them trigger damage application
func attack(target: Targetable) -> void:
	if not can_attack(target):
		return

	attack_cooldown_ready = false

	match attack_type:
		Types.AttackType.HITSCAN:
			_apply_damage(target)
		Types.AttackType.PROJECTILE:
			_schedule_delayed_damage(target)
		_:
			push_error("Unknown attack type: %s" % attack_type)

	_start_attack_cooldown()

func _start_attack_cooldown() -> void:
	await get_tree().create_timer(1.0 / attack_speed).timeout
	attack_cooldown_ready = true

func _apply_damage(target: Targetable) -> void:
	target.take_damage(damage)

func _schedule_delayed_damage(target: Targetable) -> void:
	var projectile: Projectile = projectile_scene.instantiate() as Projectile
	projectile.global_position = global_position
	projectile.origin = global_position
	projectile.target = target
	projectile.hit_target.connect(func(t: Targetable): _apply_damage(t))

	get_tree().current_scene.add_child(projectile)
